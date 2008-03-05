Return-Path: <linux-kernel-owner+w=401wt.eu-S1759949AbYCEXuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759949AbYCEXuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:50:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755812AbYCEXtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:49:52 -0500
Received: from smtp1.dnsmadeeasy.com ([205.234.170.144]:44160 "EHLO
	smtp1.dnsmadeeasy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786AbYCEXtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:49:52 -0500
X-Greylist: delayed 1684 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Mar 2008 18:49:52 EST
X-Authenticated-Name: js.dnsmadeeasy
X-Transit-System: In case of SPAM please contact abuse@dnsmadeeasy.com
Message-ID: <47CF2B07.2050503@avtrex.com>
Date: Wed, 05 Mar 2008 15:21:43 -0800
From: David Daney <ddaney@avtrex.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Olivier Galibert <galibert@pobox.com>, Michael Matz <matz@suse.de>,
       Joe Buck <Joe.Buck@synopsys.COM>, Jan Hubicka <hubicka@ucw.cz>,
       Aurelien Jarno <aurelien@aurel32.net>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction
  flag
References: <20080305153020.GA24631@volta.aurel32.net> <47CEC3AA.6080709@zytor.com> <20080305195834.GA17267@synopsys.com> <20080305202319.GA17053@volta.aurel32.net> <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de> <20080305204234.GB17267@synopsys.com> <20080305204945.GB14011@atrey.karlin.mff.cuni.cz> <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de> <20080305212005.GC17267@synopsys.com> <Pine.LNX.4.64.0803052241170.20583@wotan.suse.de> <20080305231712.GC2649@dspnet.fr.eu.org>
In-Reply-To: <20080305231712.GC2649@dspnet.fr.eu.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2008 23:21:44.0909 (UTC) FILETIME=[AD5567D0:01C87F17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olivier Galibert wrote:
> On Wed, Mar 05, 2008 at 10:43:33PM +0100, Michael Matz wrote:
>> FWIW I don't think it's a release blocker for 4.3.0.  The error is arcane 
>> and happens seldomly if at all.  And only on unfixed kernels.  A program 
>> needs to do std explicitely, which most don't do _and_ get hit by a signal 
>> while begin in a std region.  This happens so seldom that it didn't occur 
>> in building the next openSuSE 11.0, and it continually builds packages 
>> with 4.3 since months.
> 
> How would you know whether it has happened?
> 

The same way you do with other bugs: You would observe unexpected behavior.

In this case probably either corrupted memory or a SIGSEGV.

David Daney
