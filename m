Return-Path: <linux-kernel-owner+w=401wt.eu-S1755772AbZD0VHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbZD0VHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 17:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757405AbZD0VHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 17:07:22 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:49962 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbZD0VHV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 17:07:21 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0904271645380.15670-100000@netrider.rowland.org>
References: <20090427193532.GA2948@kroah.com> <Pine.LNX.4.44L0.0904271645380.15670-100000@netrider.rowland.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 27 Apr 2009 23:07:04 +0200
Message-ID: <ac3eb2510904271407l7a480744s36d60025948aebd8@mail.gmail.com>
Subject: Re: usbutils 0.81 release
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 22:48, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 27 Apr 2009, Greg KH wrote:
>
>> Kay Sievers (11):
>>       rename configure.in -> configure.ac
>>       delete spec file
>
> Why delete the spec file?  Don't you want to keep it for people who
> would like to build an RPM?

Spec files are much too distro specific, they all contain custom
distro variables, reference package names which are not the same
across distros. They usually don't even agree on the directories the
stuff is installed into. The usb.ids file as an example, is in a
different location on every distro i have seen. :)

There is in most cases no point in keeping outdated spec files or
debian directories in upstream source packages. The best when updating
a package, is to start with the one that is in the source rpm of the
distro one uses.

Thanks,
Kay
