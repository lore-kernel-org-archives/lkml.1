Return-Path: <linux-kernel-owner+w=401wt.eu-S1762187AbZATTsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762187AbZATTsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 14:48:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755923AbZATTrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 14:47:51 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:37261 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904AbZATTrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 14:47:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qElLIzyWOUeUWvi5A8jY6acHxXWqGcMIWwJE54rt3QFObaBXUBj+RNedeL7LbhKv5K
         H4S63z38Ev9etg/uPt/nzeF4RJS82Sio3+J5qhfHg6RCXD1P1boE33ywhbcImb1T679f
         9T9/J0ys+GkOcqOqB5cjCaJ4u5RVeBaaTMi5Q=
MIME-Version: 1.0
In-Reply-To: <1232441867.26012.20.camel@hyperion>
References: <a80c86b70901181218v4fbb9ad8ndc3a421c2772654b@mail.gmail.com>
	 <1232441867.26012.20.camel@hyperion>
Date: Tue, 20 Jan 2009 14:42:01 -0500
Message-ID: <3e8340490901201142l3787fbaep71351beb7a04e1cf@mail.gmail.com>
Subject: Re: LVM and root.
From: Bryan Donlan <bdonlan@gmail.com>
To: Cristi Magherusan <Cristi.Magherusan@net.utcluj.ro>
Cc: Prateek Donni <prateek.donni@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 3:57 AM, Cristi Magherusan
<Cristi.Magherusan@net.utcluj.ro> wrote:
> On Mon, 2009-01-19 at 01:48 +0530, Prateek Donni wrote:
>> Changing size of root partition in LVM . Is it possible .. ?
> The LVM volume could be resized, but for resizing the partition you may
> need to use a live CD, since IIRC you cannot resize a mounted
> filesystem.

Many filesystems actually do support online resize - ext3, reiserfs,
and xfs I know support it, as well as others, probably. Of course,
running fsck -> resize -> fsck from a livecd is probably the /safest/
route...
