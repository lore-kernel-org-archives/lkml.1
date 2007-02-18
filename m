Return-Path: <linux-kernel-owner+w=401wt.eu-S1751452AbXBRRAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbXBRRAH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 12:00:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbXBRRAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 12:00:06 -0500
Received: from main.gmane.org ([80.91.229.2]:60030 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbXBRRAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 12:00:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Ryan M." <fumarole@gmail.com>
Subject: Re: 2.6.20-ck1
Date: Sun, 18 Feb 2007 08:54:17 -0800
Message-ID: <era0c3$ao4$1@sea.gmane.org>
References: <200702162110.03355.kernel@kolivas.org>	<1c1c86360702171814m35265b01pe391df87d5f9db76@mail.gmail.com> <cone.1171766339.618918.14587.501@kolivas.org>
Reply-To: fumarole@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: ppp-69-106-223-201.dsl.chi2ca.pacbell.net
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
In-Reply-To: <cone.1171766339.618918.14587.501@kolivas.org>
Cc: ck@vds.kolivas.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Con,


Con Kolivas wrote:

> Would some -ck user on the mailing list like to perform a set of 
> interbench benchmarks? They're pretty straight forward to do; see:

Here are my results for AMD 3200+ (2.2Ghz, uniprocessor), 1gb RAM, 10,000RPM SATA drive after clean boots into runlevel 1.
2.6.19-ck1 data are included at the bottom.



Using 1116777 loops per ms, running every load for 30 seconds
Benchmarking kernel 2.6.20 at datestamp 200702172323

--- Benchmarking simulated cpu of Audio in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	  0.003 +/- 0.00314    0.005		 100	        100
Video	  0.002 +/- 0.00254    0.006		 100	        100
X	  0.996 +/- 2.57          10		 100	        100
Burn	  0.002 +/- 0.00241    0.011		 100	        100
Write	  0.053 +/- 0.6           10		 100	        100
Read	  0.009 +/- 0.0117     0.114		 100	        100
Compile	  0.023 +/- 0.368       9.01		 100	        100
Memload	  0.013 +/- 0.0578     0.948		 100	        100

--- Benchmarking simulated cpu of Video in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	  0.002 +/- 0.00261    0.004		 100	        100
X	    3.5 +/- 8.38        26.7		 100	       86.7
Burn	  0.002 +/- 0.00235    0.006		 100	        100
Write	  0.072 +/- 1.18        26.7		 100	       99.7
Read	  0.007 +/- 0.00891    0.063		 100	        100
Compile	  0.031 +/- 0.677       21.7		 100	       99.9
Memload	  0.014 +/- 0.0688      1.57		 100	        100

--- Benchmarking simulated cpu of X in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	  0.026 +/- 0.231          2		98.7	         98
Video	   10.8 +/- 23.4          69		37.7	       30.2
Burn	  0.026 +/- 0.231          2		98.7	         98
Write	  0.543 +/- 3.54          55		89.6	       86.8
Read	  0.026 +/- 0.231          2		98.7	         98
Compile	    1.8 +/- 23.7         405		80.5	       77.9
Memload	  0.029 +/- 0.238          2		98.7	       97.7

--- Benchmarking simulated cpu of Gaming in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU
None	      0 +/- 0              0		 100
Video	   63.2 +/- 64.8        66.5		61.3
X	    100 +/- 213         1392		49.9
Burn	    349 +/- 375          400		22.3
Write	   46.4 +/- 112          891		68.3
Read	   8.45 +/- 8.63        12.2		92.2
Compile	    437 +/- 505         1138		18.6
Memload	   15.4 +/- 23.8         159		86.7



Using 1116777 loops per ms, running every load for 30 seconds
Benchmarking kernel 2.6.20-ck1 at datestamp 200702180758

--- Benchmarking simulated cpu of Audio in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	  0.002 +/- 0.00242    0.005		 100	        100
Video	  0.002 +/- 0.00241    0.003		 100	        100
X	  0.206 +/- 0.98           7		 100	        100
Burn	  0.002 +/- 0.00238    0.003		 100	        100
Write	  0.014 +/- 0.204          5		 100	        100
Read	  0.007 +/- 0.00847    0.062		 100	        100
Compile	  0.007 +/- 0.00783    0.062		 100	        100
Memload	  0.036 +/- 0.254          5		 100	        100

--- Benchmarking simulated cpu of Video in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	  0.002 +/- 0.00247    0.018		 100	        100
X	  0.236 +/- 1.15        16.7		 100	       99.9
Burn	  0.002 +/- 0.00252    0.012		 100	        100
Write	  0.006 +/- 0.041          1		 100	        100
Read	  0.007 +/- 0.0168     0.486		 100	        100
Compile	  0.007 +/- 0.0278     0.643		 100	        100
Memload	  0.031 +/- 0.247          5		 100	        100

--- Benchmarking simulated cpu of X in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	  0.049 +/- 0.465          7		98.7	       97.7
Video	   14.1 +/- 26.3          68		36.2	       26.7
Burn	  0.016 +/- 0.173          2		99.3	       98.7
Write	  0.413 +/- 1.7           10		90.6	       87.2
Read	  0.013 +/- 0.141          2		 100	         99
Compile	  0.116 +/- 0.794          8		96.8	       95.4
Memload	  0.292 +/- 2.51          36		97.4	       95.1

--- Benchmarking simulated cpu of Gaming in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU
None	      0 +/- 0              0		 100
Video	     66 +/- 66.2          73		60.2
X	    100 +/- 213         1392		49.9
Burn	    370 +/- 457          560		21.3
Write	   32.1 +/- 47.7         204		75.7
Read	   7.08 +/- 7.43        9.78		93.4
Compile	    437 +/- 532          820		18.6
Memload	   18.7 +/- 31.1         211		84.3


Using 1116777 loops per ms, running every load for 30 seconds
Benchmarking kernel 2.6.19.1-ck1 at datestamp 200702180820

--- Benchmarking simulated cpu of Audio in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	  0.002 +/- 0.00234    0.003		 100	        100
Video	  0.002 +/- 0.00243    0.004		 100	        100
X	  0.235 +/- 1.08           7		 100	        100
Burn	  0.002 +/- 0.00269    0.025		 100	        100
Write	  0.003 +/- 0.00392    0.012		 100	        100
Read	  0.007 +/- 0.00911    0.102		 100	        100
Compile	   0.01 +/- 0.0431     0.637		 100	        100
Memload	  0.029 +/- 0.21        3.88		 100	        100

--- Benchmarking simulated cpu of Video in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	  0.002 +/- 0.00237    0.008		 100	        100
X	  0.235 +/- 1.15        16.7		 100	       99.9
Burn	  0.002 +/- 0.0025     0.004		 100	        100
Write	  0.004 +/- 0.0379       1.6		 100	        100
Read	  0.006 +/- 0.00959    0.249		 100	        100
Compile	  0.006 +/- 0.0356      1.18		 100	        100
Memload	   0.04 +/- 0.296       6.01		 100	        100

--- Benchmarking simulated cpu of X in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None	  0.006 +/- 0.0817         1		 100	       99.3
Video	   14.2 +/- 26.5          68		  36	       26.6
Burn	  0.006 +/- 0.0817         1		 100	       99.3
Write	  0.036 +/- 0.379          5		99.3	       98.3
Read	  0.006 +/- 0.0817         1		 100	       99.3
Compile	  0.006 +/- 0.0817         1		 100	       99.3
Memload	  0.079 +/- 0.935         14		99.3	       98.3

--- Benchmarking simulated cpu of Gaming in the presence of simulated ---
Load	Latency +/- SD (ms)  Max Latency   % Desired CPU
None	      0 +/- 0              0		 100
Video	     66 +/- 66.3          73		60.2
X	    100 +/- 209         1292		49.9
Burn	    370 +/- 457          560		21.3
Write	     22 +/- 23.9        96.9		81.9
Read	   7.05 +/- 7.4         9.66		93.4
Compile	    428 +/- 518          646		18.9
Memload	     19 +/- 31.1         213		  84











> 
> http://interbench.kolivas.org
> 
> -- 
> -ck
> 


