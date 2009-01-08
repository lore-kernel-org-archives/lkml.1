Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbZAHKnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbZAHKnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 05:43:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbZAHKmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 05:42:51 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41358 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751010AbZAHKmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 05:42:50 -0500
Date: Thu, 8 Jan 2009 10:43:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael Stone <michael@laptop.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: RFC: Network privilege separation.
Message-ID: <20090108104305.7b271053@lxorguk.ukuu.org.uk>
In-Reply-To: <20090108023111.GJ3164@didacte.laptop.org>
References: <1231307334-9542-1-git-send-email-michael@laptop.org>
	<87mye2yg8a.fsf@basil.nowhere.org>
	<20090108023111.GJ3164@didacte.laptop.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Conclusion: so far as I can see, RLIMIT_NETWORK is, in every way, a smaller
> expansion of the end user's trusted code base and should therefore be preferred
> in comparison netfilter-based solutions for process-level network privilege
> separation tasks. Do you see things differently?

If you have the same uid then you can just use ptrace to drive another
task with that uid to do the creations for you. Chances are you can also
attack shared executable files (eg that uids .bashrc)

That to me says controlling network access is only useful as part of a
more fine grained and general purpose interface. We already have that
interface in the form of things like SELinux. We already have systems
actively using it to control stuff like which ports are accessed by some
services.

Alan
