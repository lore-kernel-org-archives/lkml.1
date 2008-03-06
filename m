Return-Path: <linux-kernel-owner+w=401wt.eu-S932232AbYCFTfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232AbYCFTfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 14:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbYCFTfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 14:35:37 -0500
Received: from rock.gnat.com ([205.232.38.15]:36323 "EHLO rock.gnat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158AbYCFTfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 14:35:37 -0500
Message-ID: <47D04782.2070802@adacore.com>
Date: Thu, 06 Mar 2008 14:35:30 -0500
From: Robert Dewar <dewar@adacore.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Jakub Jelinek <jakub@redhat.com>,
       NightStrike <nightstrike@gmail.com>,
       Olivier Galibert <galibert@pobox.com>,
       Chris Lattner <clattner@apple.com>, Michael Matz <matz@suse.de>,
       Richard Guenther <richard.guenther@gmail.com>,
       Joe Buck <Joe.Buck@synopsys.com>, Jan Hubicka <hubicka@ucw.cz>,
       Aurelien Jarno <aurelien@aurel32.net>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction
 flag
References: <738B72DB-A1D6-43F8-813A-E49688D05771@apple.com> 	 <20080306135139.GA5236@dspnet.fr.eu.org> 	 <b609cb3b0803060737xa0c3c0byb51d51af797eb81f@mail.gmail.com> 	 <6dc9ffc80803060743h502fc96bj6117ef87a8555c3a@mail.gmail.com> 	 <47D012B4.3020104@zytor.com> 	 <20080306162353.GF24887@devserv.devel.redhat.com> 	 <6dc9ffc80803060858i7d4e8b56o99ff8ad301a5cc1a@mail.gmail.com> 	 <47D024AA.9010300@zytor.com> 	 <6dc9ffc80803060914x187049a2hb24ef501baf55601@mail.gmail.com> 	 <47D0271F.4070705@zytor.com> <6dc9ffc80803060934q3df9b5b5gf336b1ed0af16820@mail.gmail.com>
In-Reply-To: <6dc9ffc80803060934q3df9b5b5gf336b1ed0af16820@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H.J. Lu wrote:

> Icc has been following psABI for years on Linux and it doesn't stop people
> using icc on Linux.  On the other hand, it may be a good idea to provide a
> workaround in gcc and enables it by default.  OSVs can fix thekernel and
> disable it by default.

How widely is icc used? I ask because we have not encocuntered one
customer using icc. We have huge numbers of customers using gcc, and
many using proprietary compilers from Sun, DEC etc, but never an icc
user?
> 
> We can even issue a message whenever the workaround is used.
> 
> H.J.

