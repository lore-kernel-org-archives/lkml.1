Return-Path: <linux-kernel-owner+w=401wt.eu-S1753427AbZKJKIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbZKJKIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 05:08:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbZKJKIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 05:08:07 -0500
Received: from forum.psychotherapie.org ([217.160.22.205]:53663 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752939AbZKJKIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 05:08:06 -0500
Date: Tue, 10 Nov 2009 11:04:50 +0100
From: Enrico Weigelt <weigelt@metux.de>
To: linux-kernel@vger.kernel.org
Subject: Re: FatELF patches...
Message-ID: <20091110100450.GB575@nibiru.local>
Reply-To: weigelt@metux.de
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> <1257103201.2865.6.camel@chumley>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257103201.2865.6.camel@chumley>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ, 
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42, 
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida, 
X-Killer: 23, endloesung, Weltuntergang, 
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Hagood <david.hagood@gmail.com> wrote:

Hi,

> I hope it's not too late for a request for consideration: if we start
> having fat binaries, could one of the "binaries" be one of the "not
> quite compiled code" formats like Architecture Neutral Distribution
> Format (ANDF), such that, given a fat binary which does NOT support a
> given CPU, you could at least in theory process the ANDF section to
> create the needed target binary? Bonus points for being able to then
> append the newly created section to the file.

If you really wanna have arch independent binaries, you need some sort 
of virtual processor. Java, LLVM, etc. The idea is far from being new, 
IMHO originally came from old Burroughs Mainframes, which ran some
Algol-tailored bytecode, driven by an interpreter in microcode.
(I'm currently desiging a new VP with similar concepts, just in case
anybody's interested).

BTW: this does not need additional kernel support - binfmt_misc 
is your friend ;-P

> As an embedded systems guy who is looking to have to support multiple
> CPU types, this is really very interesting to me.

Just for the protocol: you want to have FatELF on embedded system ?


cu
-- 
---------------------------------------------------------------------
 Enrico Weigelt    ==   metux IT service - http://www.metux.de/
---------------------------------------------------------------------
 Please visit the OpenSource QM Taskforce:
 	http://wiki.metux.de/public/OpenSource_QM_Taskforce
 Patches / Fixes for a lot dozens of packages in dozens of versions:
	http://patches.metux.de/
---------------------------------------------------------------------
