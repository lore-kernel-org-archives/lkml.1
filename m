Return-Path: <linux-kernel-owner+w=401wt.eu-S1030326AbXBRGFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030326AbXBRGFl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 01:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030318AbXBRGFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 01:05:41 -0500
Received: from mail31.syd.optusnet.com.au ([211.29.132.102]:41958 "EHLO
	mail31.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030326AbXBRGFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 01:05:40 -0500
From: Con Kolivas <kernel@kolivas.org>
To: ck@vds.kolivas.org
Subject: Re: [ck] Re: 2.6.20-ck1
Date: Sun, 18 Feb 2007 17:05:33 +1100
User-Agent: KMail/1.9.5
Cc: "mdew." <some.nzguy@gmail.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <200702162110.03355.kernel@kolivas.org> <1c1c86360702171814m35265b01pe391df87d5f9db76@mail.gmail.com> <cone.1171766339.618918.14587.501@kolivas.org>
In-Reply-To: <cone.1171766339.618918.14587.501@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702181705.34231.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 February 2007 13:38, Con Kolivas wrote:
> mdew . writes:
> > On 2/16/07, Con Kolivas <kernel@kolivas.org> wrote:
> >> This patchset is designed to improve system responsiveness and
> >> interactivity. It is configurable to any workload but the default -ck
> >> patch is aimed at the desktop and -cks is available with more emphasis
> >> on serverspace.
> >>
> >> Apply to 2.6.20
> >
> > any benchmarks for 2.6.20-ck vs 2.6.20?
>
> Would some -ck user on the mailing list like to perform a set of interbench
> benchmarks? They're pretty straight forward to do; see:
>
> http://interbench.kolivas.org

I couldn't take down any lower power machine for these benchmarks... A lower 
power single cpu machine would be better for this. Feel free to throw any 
other benchmarks at it.

This core2 duo 2.4 GHz with 2GB ram and 7200 rpm 16MB cache hard drive is not 
too discrimanatory, but here are the results (use fixed font to see):

Using 2392573 loops per ms, running every load for 30 seconds
Benchmarking kernel 2.6.20 at datestamp 200702181608

--- Benchmarking simulated cpu of Audio in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	  0.002 +/- 0.00329    0.006		 100	        100
Video	  0.002 +/- 0.00356     0.01		 100	        100
X	  0.007 +/- 0.0819         2		 100	        100
Burn	  0.002 +/- 0.00335    0.005		 100	        100
Write	  0.105 +/- 1.55        35.5		 100	        100
Read	  0.006 +/- 0.00707    0.014		 100	        100
Compile	  0.312 +/- 5.61         135		99.8	       99.8
Memload	   0.01 +/- 0.037       0.72		 100	        100

--- Benchmarking simulated cpu of Video in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	  0.004 +/- 0.00431    0.017		 100	        100
X	  0.006 +/- 0.00608    0.013		 100	        100
Burn	  0.003 +/- 0.00392    0.012		 100	        100
Write	  0.097 +/- 3.44         144		99.8	       99.8
Read	  0.005 +/- 0.00523    0.013		 100	        100
Compile	  0.059 +/- 1.2         36.7		99.8	       99.8
Memload	   0.01 +/- 0.0767      1.85		 100	        100

--- Benchmarking simulated cpu of X in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	  0.056 +/- 0.379          3		98.4	       96.7
Video	  0.033 +/- 0.258          2		98.7	       97.7
Burn	      0 +/- 0              0		 100	        100
Write	  0.051 +/- 0.67        11.2		99.3	         99
Read	  0.053 +/- 0.384          3		  98	       96.7
Compile	  0.139 +/- 2.29          39		  99	       98.6
Memload	  0.166 +/- 2.25          39		98.1	       97.1

--- Benchmarking simulated cpu of Gaming in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU
None	  0.551 +/- 0.553      0.665		99.5
Video	  0.594 +/- 0.596      0.656		99.4
X	  0.019 +/- 0.317       5.49		 100
Burn	    179 +/- 186          193		35.9
Write	   1.16 +/- 5.87        69.2		98.9
Read	  0.876 +/- 0.884       1.31		99.1
Compile	    193 +/- 209          499		34.1
Memload	   1.11 +/- 1.59        15.3		98.9


Using 2392573 loops per ms, running every load for 30 seconds
Benchmarking kernel 2.6.20-ck1 at datestamp 200702181542

--- Benchmarking simulated cpu of Audio in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	  0.002 +/- 0.00333    0.005		 100	        100
Video	  0.004 +/- 0.0309     0.717		 100	        100
X	  0.008 +/- 0.124       2.99		 100	        100
Burn	  0.002 +/- 0.00339    0.005		 100	        100
Write	   0.03 +/- 0.228       2.99		 100	        100
Read	  0.005 +/- 0.00636    0.017		 100	        100
Compile	  0.041 +/- 0.268       3.06		 100	        100
Memload	   0.31 +/- 4.83         6.3		 100	        100

--- Benchmarking simulated cpu of Video in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	  0.003 +/- 0.00383    0.014		 100	        100
X	  0.008 +/- 0.143       5.99		 100	        100
Burn	  0.003 +/- 0.00383    0.009		 100	        100
Write	  0.023 +/- 0.219       4.57		 100	        100
Read	  0.004 +/- 0.0047     0.017		 100	        100
Compile	  0.027 +/- 0.214       3.73		 100	        100
Memload	  0.015 +/- 0.113          3		 100	        100

--- Benchmarking simulated cpu of X in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	      0 +/- 0.000351   0.006		 100	        100
Video	      0 +/- 0              0		 100	        100
Burn	      0 +/- 0.000293   0.005		 100	        100
Write	      0 +/- 5.85e-05   0.001		 100	        100
Read	  0.003 +/- 0.0585         1		 100	       99.7
Compile	   0.15 +/- 1.09          14		97.3	       95.6
Memload	      0 +/- 0.00105    0.018		 100	        100

--- Benchmarking simulated cpu of Gaming in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU
None	      0 +/- 0              0		 100
Video	  0.006 +/- 0.115       1.99		 100
X	      0 +/- 0.00283    0.049		 100
Burn	    187 +/- 225          270		34.8
Write	   1.38 +/- 6.8         99.4		98.6
Read	      0 +/- 0              0		 100
Compile	    205 +/- 246          440		32.8
Memload	  0.005 +/- 0.0295     0.282		 100


-- 
-ck
