Return-Path: <linux-kernel-owner+w=401wt.eu-S1753108Ab0AKQrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab0AKQrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 11:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939Ab0AKQrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 11:47:41 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:37745 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab0AKQrk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 11:47:40 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1001111008080.2873-100000@iolanthe.rowland.org>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
	 <Pine.LNX.4.44L0.1001111008080.2873-100000@iolanthe.rowland.org>
Date: Mon, 11 Jan 2010 17:47:38 +0100
Message-ID: <2f83750a1001110847r2b65b433q2ff6f6714d42861a@mail.gmail.com>
Subject: Re: [linux-pm] 2.6.33-rc3-git3: Reported regressions 2.6.31 -> 2.6.32
From: Clemens Fruhwirth <clemens@endorphin.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 4:15 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sun, 10 Jan 2010, Rafael J. Wysocki wrote:
>
>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=14841
>> Subject       : unable to enumerate USB device on port X after suspend/resume
>> Submitter     : Fruhwirth Clemens <clemens@endorphin.org>
>> Date          : 2009-12-19 11:45 (23 days old)
>
> This bug has been resolved as WILL NOT FIX.  It ended up having nothing
> to do with suspend or resume, it was caused by strange behavior in the
> device hardware.

Should we track "automatic fallback to USB 1.1" as feature request?
You already said that this isn't easily possible with the way the USB
stack is structured at the moment (connect-centric-view instead of
port-centric-view). However, Windows does that fallback and I'm afraid
that this is the default device testing scenario.
-- 
Fruhwirth Clemens http://clemens.endorphin.org
