Return-Path: <linux-kernel-owner+w=401wt.eu-S937192AbXGUBKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937192AbXGUBKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 21:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759508AbXGUBJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 21:09:57 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:61404 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbXGUBJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 21:09:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=nIkYaG2X6Z4kAQ9xqZKOTA+EC8ie/N8i4x7Tfy7UmD6z2OZvnNVZjgDDdTP5/AMWFJnMibhVAtjwHyXgOVcwxAH3wuwSEynAQQFSpn4RvU02DSTFKQEmdjJRfDOzI6QvuBnCcET6JY4K57mJDLNuu4mquECH5jG4DnTOIhbkEkM=
Message-ID: <3ae72650707201809l33019f56i202c1a1ddd61007f@mail.gmail.com>
Date: Sat, 21 Jul 2007 03:09:55 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Dave Jones" <davej@redhat.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: film at 11: kernel update breaks udev.
In-Reply-To: <20070721010424.GA4411@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070721010424.GA4411@redhat.com>
X-Google-Sender-Auth: d5404cfbf32fc688
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/07, Dave Jones <davej@redhat.com> wrote:
> Just one of my machines to 2.6.22.1, and got this during boot..
>
> Starting udev: udevd-event[619]: udev_node_symlink: symlink(../../sdc/dev/disk/by-uuid/2d773baf-8174-10a6-14db-a78e0e676e89) failed: File exists
>
> Under 2.6.21, all was fine.
>
> sdc is one disk of a 3 disk raid5 set.
> The raidset still manages to come up despite this.
>
> This is a Fedora 7 box, with udev-106-4.1.fc7
>
> What changed this time?

CONFIG_BLK_DEV_BSG=y?

There's a name-clash, because bsg tries to create devices with the same name.
James sent a patch, it's on lkml.

Kay
