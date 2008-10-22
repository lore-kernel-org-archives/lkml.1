Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbYJVTfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbYJVTfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757092AbYJVTfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:35:10 -0400
Received: from mailout06.t-online.de ([194.25.134.19]:45540 "EHLO
	mailout06.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827AbYJVTfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:35:09 -0400
Message-ID: <48FF8065.9@t-online.de>
Date: Wed, 22 Oct 2008 21:35:01 +0200
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080926)
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27.1: install conflict about /lib/firmware
References: <48F78C5C.8080907@t-online.de> <48F7AB05.50103@msgid.tls.msk.ru>
In-Reply-To: <48F7AB05.50103@msgid.tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ID: XNChAZZOZhtuOcH-6NS+cBcqO5PfpjVBPHbATcVfXn4tX9UNNYBpi2uGief4McGZME
X-TOI-MSGID: 1c253eee-5cec-4149-a9c8-cb3f8ee9d093
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
> 
>> Wouldn't it be more consistent to put the firmware files in a
>> kernel specific directory, e.g. in /lib/firmware/2.6.27.1 or
>> /lib/modules/2.6.27.1/firmware ?
> 
> No, because the firmware is not kernel-dependent, but device-dependent.
> It were deliberate choice.
> 

This is not about some api incompatibility, but about a packaging
conflict. Even if each firmware file is kernel-independent, the
list of files is not. If I build and install *.rpm or *.deb files
for a new kernel version (probably with a changed set of modules),
then there is a high chance that the new package for /lib/\
firmware provides a new list of files, not suitable for another
kernel.


Regards

Harri

