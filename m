Return-Path: <linux-kernel-owner+w=401wt.eu-S965483AbXBRG1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965483AbXBRG1k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 01:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030342AbXBRG1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 01:27:40 -0500
Received: from lollipop.listbox.com ([208.210.124.78]:60116 "EHLO
	lollipop.listbox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965483AbXBRG1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 01:27:39 -0500
X-Greylist: delayed 695 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Feb 2007 01:27:39 EST
Subject: Re: [ck] Re: 2.6.20-ck1
From: Rodney Gordon II <meff@pobox.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: "mdew ." <some.nzguy@gmail.com>, ck@vds.kolivas.org,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <cone.1171766339.618918.14587.501@kolivas.org>
References: <200702162110.03355.kernel@kolivas.org>
	 <1c1c86360702171814m35265b01pe391df87d5f9db76@mail.gmail.com>
	 <cone.1171766339.618918.14587.501@kolivas.org>
Content-Type: multipart/mixed; boundary="=-3IQNOUUSkUWaiSkolj1z"
Date: Sun, 18 Feb 2007 00:15:57 -0600
Message-Id: <1171779357.4740.5.camel@ghreen.sphere>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3IQNOUUSkUWaiSkolj1z
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sun, 2007-02-18 at 13:38 +1100, Con Kolivas wrote:
> mdew . writes:
> 
> > On 2/16/07, Con Kolivas <kernel@kolivas.org> wrote:
> >> This patchset is designed to improve system responsiveness and interactivity.
> >> It is configurable to any workload but the default -ck patch is aimed at the
> >> desktop and -cks is available with more emphasis on serverspace.
> >>
> >> Apply to 2.6.20
> > 
> > any benchmarks for 2.6.20-ck vs 2.6.20?
> 
> Would some -ck user on the mailing list like to perform a set of interbench 
> benchmarks? They're pretty straight forward to do; see:
> 
> http://interbench.kolivas.org
> 
> --
> -ck

Here are some benches comparing 2.6.18-4-686 (Debian sid stock) and
2.6.20-ck1-mt1 (2.6.20-ck1 + sched-idleprio-1.11-2.0.patch)

I know it's not what was asked for, but it might be useful for review of
anyone using Debian kernels considering ck patches :)

Take a look.

-r
-- 
Rodney "meff" Gordon II -*- meff@pobox.com
Systems Administrator / Coder Geek -*- Open yourself to OpenSource

--=-3IQNOUUSkUWaiSkolj1z
Content-Disposition: attachment; filename=2.6.18-4-686.log
Content-Type: text/x-log; name=2.6.18-4-686.log; charset=utf-8
Content-Transfer-Encoding: 7bit


Using 1816966 loops per ms, running every load for 30 seconds
Benchmarking kernel 2.6.18-4-686 at datestamp 200702172244

--- Benchmarking simulated cpu of Audio in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	  0.005 +/- 0.00545    0.008		 100	        100
Video	  0.086 +/- 0.661        6.7		 100	        100
X	   0.03 +/- 0.272       5.32		 100	        100
Burn	  0.005 +/- 0.00565     0.01		 100	        100
Write	  0.043 +/- 0.281       5.28		 100	        100
Read	   0.01 +/- 0.0293     0.537		 100	        100
Compile	  0.013 +/- 0.119       2.91		 100	        100
Memload	  0.033 +/- 0.289        6.2		 100	        100

--- Benchmarking simulated cpu of Video in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	  0.024 +/- 0.556       16.7		 100	       99.9
X	  0.874 +/- 3.78        16.7		 100	       94.9
Burn	  0.005 +/- 0.00559    0.008		 100	        100
Write	  0.128 +/- 1.36        24.6		 100	       99.6
Read	  0.524 +/- 2.93        16.7		 100	       96.9
Compile	  0.136 +/- 1.43        17.3		 100	       99.3
Memload	  0.751 +/- 3.48        17.3		 100	       95.7

--- Benchmarking simulated cpu of X in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	  0.293 +/- 1.34          10		92.3	       89.2
Video	  0.606 +/- 2.32          18		89.8	       84.6
Burn	  0.526 +/- 1.93          10		90.6	       85.1
Write	   1.35 +/- 7.79          92		87.4	         84
Read	    2.3 +/- 7.4           44		78.8	         72
Compile	   2.09 +/- 7.75          72		78.5	       72.9
Memload	  0.767 +/- 2.82          24		87.5	       82.2

--- Benchmarking simulated cpu of Gaming in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU
None	   2.64 +/- 9.31        50.6		97.4
Video	  0.063 +/- 0.297       5.07		99.9
X	  0.061 +/- 0.377       6.48		99.9
Burn	    183 +/- 194          400		35.3
Write	   1.32 +/- 6.21        80.9		98.7
Read	   4.98 +/- 7           34.5		95.3
Compile	    210 +/- 228          449		32.3
Memload	   4.57 +/- 11.2          83		95.6



--=-3IQNOUUSkUWaiSkolj1z
Content-Disposition: attachment; filename=2.6.20-ck1-mt1.log
Content-Type: text/x-log; name=2.6.20-ck1-mt1.log; charset=utf-8
Content-Transfer-Encoding: 7bit


Using 1816966 loops per ms, running every load for 30 seconds
Benchmarking kernel 2.6.20-ck1-mt1 at datestamp 200702172307

--- Benchmarking simulated cpu of Audio in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	  0.005 +/- 0.00517    0.009		 100	        100
Video	  0.016 +/- 0.017      0.022		 100	        100
X	  0.018 +/- 0.13        3.17		 100	        100
Burn	  0.005 +/- 0.00551    0.013		 100	        100
Write	  0.016 +/- 0.0489      1.07		 100	        100
Read	  0.016 +/- 0.102       2.48		 100	        100
Compile	  0.051 +/- 0.421          7		 100	        100
Memload	  0.012 +/- 0.08        1.55		 100	        100

--- Benchmarking simulated cpu of Video in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	  0.088 +/- 1.18        16.7		 100	       99.5
X	  0.014 +/- 0.0153     0.026		 100	        100
Burn	  0.005 +/- 0.00553    0.016		 100	        100
Write	  0.057 +/- 0.734       16.7		 100	       99.8
Read	  0.016 +/- 0.0187      0.21		 100	        100
Compile	  0.042 +/- 0.328       5.59		 100	        100
Memload	  0.014 +/- 0.0883      1.93		 100	        100

--- Benchmarking simulated cpu of X in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	  0.033 +/- 0.258          2		98.7	       97.7
Video	  0.033 +/- 0.258          2		98.7	       97.7
Burn	  0.046 +/- 0.337          3		98.4	         97
Write	  0.129 +/- 0.777          7		96.5	       94.4
Read	  0.292 +/- 1.75          18		94.4	       91.6
Compile	  0.473 +/- 2.66          28		  92	         89
Memload	  0.178 +/- 0.98           8		96.8	       93.8

--- Benchmarking simulated cpu of Gaming in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU
None	  0.124 +/- 0.126      0.369		99.9
Video	  0.439 +/- 0.44       0.459		99.6
X	  0.444 +/- 0.469       2.98		99.6
Burn	    198 +/- 236          280		33.6
Write	  0.509 +/- 0.752       7.59		99.5
Read	   2.02 +/- 4.93        31.8		  98
Compile	    201 +/- 239          299		33.2
Memload	   3.39 +/- 5.18        31.3		96.7



--=-3IQNOUUSkUWaiSkolj1z--

