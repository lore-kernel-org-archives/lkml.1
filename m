Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbYCKINr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbYCKINr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 04:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbYCKINf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 04:13:35 -0400
Received: from n5.bullet.mail.tp2.yahoo.com ([203.188.202.86]:43656 "HELO
	n5.bullet.mail.tp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751384AbYCKINe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 04:13:34 -0400
X-Yahoo-Newman-Id: 151551.10380.bm@omp415.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=3NixIunjaq/atRN3L52lLyUMn7QX+EBUUAPe84CrJTdZ3fuEWpsB8V7CZx58am1yT3x7LD26wWrhOuLuF7kmZVZaUUMR/O2z2I1XN894DTVidZPIMR77uiLh/R44vY9HaRh2tCVygAx1nn6besjImMRcs1W2cSabA9WKmXlLNHs=  ;
X-YMail-OSG: fojRRiQVM1ksVqY0ndjp7UfNh78438oWv9tj4qZAn8abpLjQdztSlqp26mz2rCRt5sShkRHWTrHzyzSSmV93XgDaUJhBXzWLRBw0Olbhpycg5bXXtWdygYjv84xxyw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] sysrq show-all-cpus
Date: Tue, 11 Mar 2008 19:12:54 +1100
User-Agent: KMail/1.9.5
Cc: Randy Dunlap <randy.dunlap@oracle.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, lwoodman@redhat.com
References: <20080310133242.0ab69084@bree.surriel.com> <20080310104628.b70af419.randy.dunlap@oracle.com> <20080310140315.1a451092@bree.surriel.com>
In-Reply-To: <20080310140315.1a451092@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803111912.55075.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 March 2008 05:03, Rik van Riel wrote:
> SysRQ-P is not always useful on SMP systems, since it usually ends up
> showing the backtrace of a CPU that is doing just fine, instead of the
> backtrace of the CPU that is having problems.
>
> This patch adds SysRQ show-all-cpus(L), which shows the backtrace of every
> active CPU in the system.  It skips idle CPUs because some SMP systems are
> just too large and we already know what the backtrace of the idle task
> looks like.
>

Yeah we need something like this. I prefer mine though ;) It shows
registers as well as stack...

http://groups.google.com.au/group/fa.linux.kernel/msg/3cd0288f7fd3be2c?dmode=source&output=gplain

It prints just a single CPU at a time, but cycles through each one.
An alternative might be to have one sysrq key used to cycle between
CPUs, and sysrq+P could then just print out a trace from the selected
CPU...


