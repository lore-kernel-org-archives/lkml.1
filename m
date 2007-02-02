Return-Path: <linux-kernel-owner+w=401wt.eu-S933300AbXBBIZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300AbXBBIZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 03:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933307AbXBBIZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 03:25:44 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:4918 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933300AbXBBIZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 03:25:44 -0500
From: "David Schwartz" <davids@webmaster.com>
To: <sofar@foo-projects.org>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Ban module license tag string termination trick
Date: Fri, 2 Feb 2007 00:24:48 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKOEBOBFAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <45C27908.1000202@foo-projects.org>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Fri, 02 Feb 2007 00:25:07 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Fri, 02 Feb 2007 00:25:07 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> to me it even screams "bypassing or a digital copyright
> enforcement system".
> that sounds really close to "D.M.C.A. violation" :)
>
> thank goodness I'm not a laywer...

It is not. GPL export is *not* a copyright enforcement scheme. (See the many
times when this was discussed on this list.) The GPL prohibits the use of
copyright enforcement schemes in sections 6 and 7.

Suppose there were some law that said that if I put "do not modify this
line" in a piece of code, you could not modify that line. The GPL would
clearly prohibit putting such a thing in a work, as that would remove from
recipients their right to modify the code -- a right guaranteed to them
under the GPL.

Same with GPL export. If it is a copyright enforcement scheme and it
prevented people from modifying the code to include the license tag
termination trick, they would not have the right to modify the code that way
which the GPL says they are supposed to have. So *if* EXPORT_GPL were a
copyright enforcement scheme, the Linux kernel containing it could not be
distributed.

The consensus view, as I understand it, is that the GPL export is a
warning/notification scheme to alert people that their use of these symbols
in non-GPL code is believed to violate the GPL *if* that code is distributed
(which the GPL export logic has no way to determine has happened or will
ever happen). It is no different than refusing a command to change the time
of day from a non-superuser.

In any event, even if you assume it is a copyright enforcement scheme, it is
not circumvention to remove or disable such a scheme with the permission of
the copyright holder. Section 2 of the GPL grants just such permission.

DS


