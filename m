Return-Path: <linux-kernel-owner+w=401wt.eu-S1757918AbYCNBg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbYCNBg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 21:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbYCNBgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 21:36:48 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:59601 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048AbYCNBgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 21:36:47 -0400
Date: Fri, 14 Mar 2008 02:36:45 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: whose job is it to include various header files?
In-Reply-To: <9a8748490803131653n7f1c2bd0m12e30d82bf936d03@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0803140227100.14822@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.1.00.0803131802020.20317@localhost.localdomain>
 <9a8748490803131653n7f1c2bd0m12e30d82bf936d03@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 14 2008 00:53, Jesper Juhl wrote:
>I agree with you completely. A file should explicitly include headers
>for the stuff it uses and not rely on implicit includes done
>elsewhere. Cleaning that up is going to touch a lot of files though
>for no real short term gain (there is a long term gain of
>maintainability though), so it's going to be a loveless job :(

But straightforward. You nuke the complete #include list of a .h/.c
file and "rebuild" it by hand, by looking at the code the .h/.c file
provides/uses and selecting appropriate #includes.
