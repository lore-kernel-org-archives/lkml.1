Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbXJHMgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbXJHMgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 08:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755764AbXJHMfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 08:35:51 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:22386 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691AbXJHMfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 08:35:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=mSAeASIcs6NMNsLroM90V9n8htFtHGnWsM46dfUBGqxDMkC/xU/dHKYop4Vp9IYWQM//w2A8E9CqrceR4hraLcoC/ImM+TB4LcZcGSfAX4AgFMYUH+h5cCdW46Hv3Rt3ZTAmMeYUDShigC4+bZmn7HKdEvFq7vebQzMPVu54uhQ=
Message-ID: <470A241B.3020307@gmail.com>
Date: Mon, 08 Oct 2007 20:35:39 +0800
From: Bo Yang <struggleyb@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: I/O report detailed meanings
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   I hope this message is going into the right newsgroup. If it is not,
please tell me, thanks.
   I have get a recent report from my machine and there is something I
do not understand.
Please take a look at the result first:

tps      rd_sec/s  wr_sec/s    avgrq-sz  avgqu-sz  await     svctm     %util
143.93   1534.74   1342.01     19.99     18.49    128.43      3.29     47.41
120.24   1424.39   1054.50     20.62     14.47    120.33      3.41     41.00
102.01   1270.69    976.18     22.03     12.87    126.20      3.80     38.79
81.82    947.90    765.50     20.94      8.94    109.30      4.07     33.27
89.55    660.23    730.50     15.53      7.76     86.61      3.80     34.01
182.51   2088.51   1199.39     18.01     16.24     89.00      3.16     57.61
73.11   1207.13    583.24     24.49      6.22     84.67      4.13     30.16
56.75    866.81    504.46     24.17      4.06     72.02      4.71     26.73
48.33    397.68    439.40     17.32      3.35     69.31      5.05     24.38
46.44    490.52    430.11     19.82      3.43     73.84      4.94     22.94
41.16    330.09    367.70     16.95      2.86     69.38      5.36     22.05
408.19  13068.02   1939.98     36.77      7.25     17.75      2.21     90.23
469.36   5933.15   1763.28     16.40      8.07     17.20      2.13     99.89
463.78   5695.35   1419.88     15.34      5.76     12.42      2.15     99.86
446.36   5535.90   1712.86     16.24      6.81     15.25      2.24     99.83
449.05   5166.26   1424.83     14.68      6.43     14.31      2.22     99.89
460.23   5596.55   1585.21     15.60      6.44     14.00      2.17     99.85
454.00   5361.55   1518.18     15.15      7.34     16.18      2.20     99.88
576.51   7397.60   1870.47     16.08      9.02     15.64      1.73     99.91
562.26   8555.19   2776.98     20.15      9.28     16.50      1.78     99.92
561.50   9001.87   3462.99     22.20     11.94     21.27      1.78     99.95
502.35   9393.50   4081.07     26.82     12.17     24.22      1.99     99.98

I am sorry that the format is still a little confused although I have
make some change to it to be more suitable for news group. Any way, I
think it is now readable.

Above is I/O report from 00:00 to 06:00 or some time in my machine.
There are about two main status in the report, in the first half the
whole load is very normal and the %util is about 40%. Suddenly, the
%util is up to 99% and the whole disk is in high load. I know, in that
time I run some I/O sensive task. But I can not understand that when the
%util is low the await/svctm/avgqu-sz is very high, but when the %util
is high the await/svctm/avgqu-sz is very low. I do not understand why?

I guess that maybe this has something to do with the way Linux deal with
I/O. But I can not figure out the real reason, could you please give me
some detailed explaination? Thanks in advance!

Regards!
Bo

