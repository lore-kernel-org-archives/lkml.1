Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbZFCFKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbZFCFKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 01:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZFCFKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 01:10:43 -0400
Received: from lnx00.cecm.usp.br ([143.107.90.10]:36624 "EHLO
	lnx00.cecm.usp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbZFCFKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 01:10:41 -0400
X-Greylist: delayed 1827 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Jun 2009 01:10:39 EDT
Date: Wed, 3 Jun 2009 01:40:12 -0300
From: Lucas Furukawa Gadani <lucas@cecm.usp.br>
To: linux-kernel@vger.kernel.org
Subject: BogoMips are incorrectly calculated
Message-ID: <20090603044012.GA17664@cecm.usp.br>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

I've noticed that sometimes BogoMips are incorrectly calculated. I'm
attaching log of last weeks showing the behaviour (not always
reproducible / not consistent). I'm also attaching dmesg output.

Kernel is ubuntu-provided, but I could test vanilla if necessary.

I've also opened bug #13433 to track this issue.

Please, CC as I'm not on the list.

-- 
Lucas

--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="bogomips.txt"

Apr 27 21:22:35 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6790.03 BogoMIPS (lpj=13580060)
Apr 27 21:22:35 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.45 BogoMIPS (lpj=13578916)
Apr 27 21:22:35 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.47 BogoMIPS (lpj=13578950)
Apr 27 21:22:35 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.48 BogoMIPS (lpj=13578979)
Apr 27 21:22:35 bluebuntu kernel: [    0.532018] Total of 4 processors activated (27158.45 BogoMIPS).
May 11 21:00:10 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.47 BogoMIPS (lpj=13578956)
May 11 21:00:10 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.46 BogoMIPS (lpj=13578923)
May 11 21:00:10 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.47 BogoMIPS (lpj=13578944)
May 11 21:00:10 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.48 BogoMIPS (lpj=13578970)
May 11 21:00:10 bluebuntu kernel: [    0.528018] Total of 4 processors activated (27157.89 BogoMIPS).
May 12 01:20:38 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6788.59 BogoMIPS (lpj=13577184)
May 12 01:20:38 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6669.73 BogoMIPS (lpj=13339469)
May 12 01:20:38 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.45 BogoMIPS (lpj=13578905)
May 12 01:20:38 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.48 BogoMIPS (lpj=13578962)
May 12 01:20:38 bluebuntu kernel: [    0.528018] Total of 4 processors activated (27037.26 BogoMIPS).
May 12 09:03:05 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6788.49 BogoMIPS (lpj=13576996)
May 12 09:03:05 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.54 BogoMIPS (lpj=13579080)
May 12 09:03:05 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.55 BogoMIPS (lpj=13579110)
May 12 09:03:05 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 967497.55 BogoMIPS (lpj=1934995114)
May 12 09:03:05 bluebuntu kernel: [    0.528018] Total of 4 processors activated (987865.15 BogoMIPS).
May 12 19:59:47 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6790.03 BogoMIPS (lpj=13580076)
May 12 19:59:47 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.45 BogoMIPS (lpj=13578918)
May 12 19:59:47 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.47 BogoMIPS (lpj=13578947)
May 12 19:59:47 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.48 BogoMIPS (lpj=13578978)
May 12 19:59:47 bluebuntu kernel: [    0.528028] Total of 4 processors activated (27158.45 BogoMIPS).
May 13 08:48:22 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.83 BogoMIPS (lpj=13579672)
May 13 08:48:22 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.46 BogoMIPS (lpj=13578934)
May 13 08:48:22 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.47 BogoMIPS (lpj=13578952)
May 13 08:48:22 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.48 BogoMIPS (lpj=13578971)
May 13 08:48:22 bluebuntu kernel: [    0.532019] Total of 4 processors activated (27158.26 BogoMIPS).
May 13 19:28:58 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.49 BogoMIPS (lpj=13578992)
May 13 19:28:58 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 36558.79 BogoMIPS (lpj=73117590)
May 13 19:28:58 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 36558.80 BogoMIPS (lpj=73117612)
May 13 19:28:58 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 36558.81 BogoMIPS (lpj=73117632)
May 13 19:28:58 bluebuntu kernel: [    0.504002] Total of 4 processors activated (116465.91 BogoMIPS).
May 14 08:43:42 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.12 BogoMIPS (lpj=13578256)
May 14 08:43:42 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 36447.83 BogoMIPS (lpj=72895678)
May 14 08:43:42 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 36447.84 BogoMIPS (lpj=72895699)
May 14 08:43:42 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 36447.86 BogoMIPS (lpj=72895737)
May 14 08:43:42 bluebuntu kernel: [    0.504002] Total of 4 processors activated (116132.68 BogoMIPS).
May 14 19:50:46 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.31 BogoMIPS (lpj=13578628)
May 14 19:50:46 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.52 BogoMIPS (lpj=13579052)
May 14 19:50:46 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.55 BogoMIPS (lpj=13579103)
May 14 19:50:46 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.55 BogoMIPS (lpj=13579112)
May 14 19:50:46 bluebuntu kernel: [    0.528018] Total of 4 processors activated (27157.94 BogoMIPS).
May 15 09:10:06 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.23 BogoMIPS (lpj=13578464)
May 15 09:10:06 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6607.22 BogoMIPS (lpj=13214457)
May 15 09:10:06 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.45 BogoMIPS (lpj=13578911)
May 15 09:10:06 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.48 BogoMIPS (lpj=13578961)
May 15 09:10:06 bluebuntu kernel: [    0.528018] Total of 4 processors activated (26975.39 BogoMIPS).
May 15 09:33:06 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.46 BogoMIPS (lpj=13578920)
May 15 09:33:06 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.45 BogoMIPS (lpj=13578908)
May 15 09:33:06 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.47 BogoMIPS (lpj=13578946)
May 15 09:33:06 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.48 BogoMIPS (lpj=13578964)
May 15 09:33:06 bluebuntu kernel: [    0.528018] Total of 4 processors activated (27157.86 BogoMIPS).
May 15 20:19:16 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6788.49 BogoMIPS (lpj=13576988)
May 15 20:19:16 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 36447.84 BogoMIPS (lpj=72895699)
May 15 20:19:16 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 36447.86 BogoMIPS (lpj=72895732)
May 15 20:19:16 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 36447.87 BogoMIPS (lpj=72895752)
May 15 20:19:16 bluebuntu kernel: [    0.504002] Total of 4 processors activated (116132.08 BogoMIPS).
May 15 22:31:59 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.55 BogoMIPS (lpj=13579100)
May 15 22:31:59 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.45 BogoMIPS (lpj=13578914)
May 15 22:31:59 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.46 BogoMIPS (lpj=13578934)
May 15 22:31:59 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.48 BogoMIPS (lpj=13578968)
May 15 22:31:59 bluebuntu kernel: [    0.528018] Total of 4 processors activated (27157.95 BogoMIPS).
May 16 02:49:38 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6788.89 BogoMIPS (lpj=13577796)
May 16 02:49:38 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.46 BogoMIPS (lpj=13578934)
May 16 02:49:38 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.47 BogoMIPS (lpj=13578954)
May 16 02:49:38 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.48 BogoMIPS (lpj=13578961)
May 16 02:49:38 bluebuntu kernel: [    0.528018] Total of 4 processors activated (27157.32 BogoMIPS).
May 16 10:23:21 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.40 BogoMIPS (lpj=13578812)
May 16 10:23:21 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 36447.84 BogoMIPS (lpj=72895683)
May 16 10:23:21 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 36447.84 BogoMIPS (lpj=72895697)
May 16 10:23:21 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 36447.87 BogoMIPS (lpj=72895740)
May 16 10:23:21 bluebuntu kernel: [    0.504002] Total of 4 processors activated (116132.96 BogoMIPS).
May 17 11:36:20 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.31 BogoMIPS (lpj=13578628)
May 17 11:36:20 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.45 BogoMIPS (lpj=13578903)
May 17 11:36:20 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.48 BogoMIPS (lpj=13578972)
May 17 11:36:20 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 967727.52 BogoMIPS (lpj=1935455056)
May 17 11:36:20 bluebuntu kernel: [    0.532027] Total of 4 processors activated (988095.77 BogoMIPS).
May 18 01:24:50 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6790.34 BogoMIPS (lpj=13580684)
May 18 01:24:50 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.45 BogoMIPS (lpj=13578906)
May 18 01:24:50 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.47 BogoMIPS (lpj=13578950)
May 18 01:24:50 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.49 BogoMIPS (lpj=13578991)
May 18 01:24:50 bluebuntu kernel: [    0.532018] Total of 4 processors activated (27158.76 BogoMIPS).
May 18 19:00:12 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.63 BogoMIPS (lpj=13579276)
May 18 19:00:12 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.46 BogoMIPS (lpj=13578920)
May 18 19:00:12 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.48 BogoMIPS (lpj=13578973)
May 18 19:00:12 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.50 BogoMIPS (lpj=13579003)
May 18 19:00:12 bluebuntu kernel: [    0.532027] Total of 4 processors activated (27158.08 BogoMIPS).
May 19 09:03:22 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.45 BogoMIPS (lpj=13578904)
May 19 09:03:22 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.48 BogoMIPS (lpj=13578961)
May 19 09:03:22 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.48 BogoMIPS (lpj=13578970)
May 19 09:03:22 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 967176.05 BogoMIPS (lpj=1934352118)
May 19 09:03:22 bluebuntu kernel: [    0.528018] Total of 4 processors activated (987544.47 BogoMIPS).
May 19 19:35:46 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.42 BogoMIPS (lpj=13578852)
May 19 19:35:46 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.45 BogoMIPS (lpj=13578905)
May 19 19:35:46 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.49 BogoMIPS (lpj=13578991)
May 19 19:35:46 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.49 BogoMIPS (lpj=13578993)
May 19 19:35:46 bluebuntu kernel: [    0.528027] Total of 4 processors activated (27157.87 BogoMIPS).
May 21 00:40:34 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.57 BogoMIPS (lpj=13579148)
May 21 00:40:34 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 36447.84 BogoMIPS (lpj=72895685)
May 21 00:40:34 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 36447.84 BogoMIPS (lpj=72895692)
May 21 00:40:34 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 36447.85 BogoMIPS (lpj=72895719)
May 21 00:40:34 bluebuntu kernel: [    0.504002] Total of 4 processors activated (116133.12 BogoMIPS).
May 21 18:47:51 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.48 BogoMIPS (lpj=13578968)
May 21 18:47:51 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 36558.85 BogoMIPS (lpj=73117713)
May 21 18:47:51 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 36558.88 BogoMIPS (lpj=73117765)
May 21 18:47:51 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 36558.88 BogoMIPS (lpj=73117779)
May 21 18:47:51 bluebuntu kernel: [    0.504002] Total of 4 processors activated (116466.11 BogoMIPS).
May 22 19:41:56 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.34 BogoMIPS (lpj=13578684)
May 22 19:41:56 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.46 BogoMIPS (lpj=13578936)
May 22 19:41:56 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.48 BogoMIPS (lpj=13578969)
May 22 19:41:56 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 967523.00 BogoMIPS (lpj=1935046007)
May 22 19:41:56 bluebuntu kernel: [    0.528018] Total of 4 processors activated (987891.29 BogoMIPS).
May 23 01:41:20 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.61 BogoMIPS (lpj=13579220)
May 23 01:41:20 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.45 BogoMIPS (lpj=13578915)
May 23 01:41:20 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.46 BogoMIPS (lpj=13578938)
May 23 01:41:20 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.47 BogoMIPS (lpj=13578959)
May 23 01:41:20 bluebuntu kernel: [    0.528018] Total of 4 processors activated (27158.01 BogoMIPS).
May 23 12:12:13 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.49 BogoMIPS (lpj=13578992)
May 23 12:12:13 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6506.38 BogoMIPS (lpj=13012765)
May 23 12:12:13 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.45 BogoMIPS (lpj=13578904)
May 23 12:12:13 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.48 BogoMIPS (lpj=13578974)
May 23 12:12:13 bluebuntu kernel: [    0.528018] Total of 4 processors activated (26874.81 BogoMIPS).
May 23 15:14:07 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.49 BogoMIPS (lpj=13578988)
May 23 15:14:07 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6528.65 BogoMIPS (lpj=13057303)
May 23 15:14:07 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.45 BogoMIPS (lpj=13578902)
May 23 15:14:07 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.48 BogoMIPS (lpj=13578970)
May 23 15:14:07 bluebuntu kernel: [    0.528018] Total of 4 processors activated (26897.08 BogoMIPS).
May 23 20:18:48 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.74 BogoMIPS (lpj=13579488)
May 23 20:18:48 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.46 BogoMIPS (lpj=13578920)
May 23 20:18:48 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.47 BogoMIPS (lpj=13578941)
May 23 20:18:48 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.48 BogoMIPS (lpj=13578979)
May 23 20:18:48 bluebuntu kernel: [    0.528017] Total of 4 processors activated (27158.16 BogoMIPS).
May 24 01:24:25 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6788.69 BogoMIPS (lpj=13577396)
May 24 01:24:25 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.53 BogoMIPS (lpj=13579064)
May 24 01:24:25 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.54 BogoMIPS (lpj=13579089)
May 24 01:24:25 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.55 BogoMIPS (lpj=13579104)
May 24 01:24:25 bluebuntu kernel: [    0.528018] Total of 4 processors activated (27157.32 BogoMIPS).
May 24 09:46:10 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6790.15 BogoMIPS (lpj=13580308)
May 24 09:46:10 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.47 BogoMIPS (lpj=13578940)
May 24 09:46:10 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.47 BogoMIPS (lpj=13578941)
May 24 09:46:10 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 967487.26 BogoMIPS (lpj=1934974528)
May 24 09:46:10 bluebuntu kernel: [    0.528018] Total of 4 processors activated (987856.35 BogoMIPS).
May 25 18:47:01 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.55 BogoMIPS (lpj=13579116)
May 25 18:47:01 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.46 BogoMIPS (lpj=13578921)
May 25 18:47:01 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.47 BogoMIPS (lpj=13578954)
May 25 18:47:01 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.48 BogoMIPS (lpj=13578968)
May 25 18:47:01 bluebuntu kernel: [    0.528018] Total of 4 processors activated (27157.97 BogoMIPS).
May 26 08:33:32 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.24 BogoMIPS (lpj=13578496)
May 26 08:33:32 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.49 BogoMIPS (lpj=13578983)
May 26 08:33:32 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.46 BogoMIPS (lpj=13578925)
May 26 08:33:32 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.48 BogoMIPS (lpj=13578972)
May 26 08:33:32 bluebuntu kernel: [    0.528018] Total of 4 processors activated (27157.68 BogoMIPS).
May 26 18:57:35 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6790.14 BogoMIPS (lpj=13580284)
May 26 18:57:35 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.48 BogoMIPS (lpj=13578966)
May 26 18:57:35 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.45 BogoMIPS (lpj=13578919)
May 26 18:57:35 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.47 BogoMIPS (lpj=13578944)
May 26 18:57:35 bluebuntu kernel: [    0.528018] Total of 4 processors activated (27158.55 BogoMIPS).
May 27 08:58:52 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.17 BogoMIPS (lpj=13578356)
May 27 08:58:52 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.47 BogoMIPS (lpj=13578955)
May 27 08:58:52 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.46 BogoMIPS (lpj=13578923)
May 27 08:58:52 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.47 BogoMIPS (lpj=13578942)
May 27 08:58:52 bluebuntu kernel: [    0.528018] Total of 4 processors activated (27157.58 BogoMIPS).
May 27 18:50:53 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.51 BogoMIPS (lpj=13579020)
May 27 18:50:53 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 967633.65 BogoMIPS (lpj=1935267300)
May 27 18:50:53 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.48 BogoMIPS (lpj=13578976)
May 27 18:50:53 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.45 BogoMIPS (lpj=13578918)
May 27 18:50:53 bluebuntu kernel: [    0.528025] Total of 4 processors activated (988002.10 BogoMIPS).
May 28 19:17:07 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6790.16 BogoMIPS (lpj=13580332)
May 28 19:17:07 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.47 BogoMIPS (lpj=13578956)
May 28 19:17:07 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.49 BogoMIPS (lpj=13578994)
May 28 19:17:07 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6730.78 BogoMIPS (lpj=13461574)
May 28 19:17:07 bluebuntu kernel: [    0.528028] Total of 4 processors activated (27099.92 BogoMIPS).
May 29 20:21:48 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.55 BogoMIPS (lpj=13579100)
May 29 20:21:48 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.47 BogoMIPS (lpj=13578958)
May 29 20:21:48 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.46 BogoMIPS (lpj=13578920)
May 29 20:21:48 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.47 BogoMIPS (lpj=13578956)
May 29 20:21:48 bluebuntu kernel: [    0.528018] Total of 4 processors activated (27157.96 BogoMIPS).
May 30 13:31:39 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.61 BogoMIPS (lpj=13579224)
May 30 13:31:39 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.49 BogoMIPS (lpj=13578990)
May 30 13:31:39 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.49 BogoMIPS (lpj=13578982)
May 30 13:31:39 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.46 BogoMIPS (lpj=13578926)
May 30 13:31:39 bluebuntu kernel: [    0.528027] Total of 4 processors activated (27158.06 BogoMIPS).
May 30 14:51:15 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.43 BogoMIPS (lpj=13578860)
May 30 14:51:15 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.45 BogoMIPS (lpj=13578909)
May 30 14:51:15 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.46 BogoMIPS (lpj=13578922)
May 30 14:51:15 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.47 BogoMIPS (lpj=13578950)
May 30 14:51:15 bluebuntu kernel: [    0.528018] Total of 4 processors activated (27157.82 BogoMIPS).
May 31 11:24:38 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.24 BogoMIPS (lpj=13578496)
May 31 11:24:38 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.48 BogoMIPS (lpj=13578967)
May 31 11:24:38 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.52 BogoMIPS (lpj=13579040)
May 31 11:24:38 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.46 BogoMIPS (lpj=13578922)
May 31 11:24:38 bluebuntu kernel: [    0.528028] Total of 4 processors activated (27157.71 BogoMIPS).
Jun  1 19:27:22 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.39 BogoMIPS (lpj=13578780)
Jun  1 19:27:22 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.48 BogoMIPS (lpj=13578970)
Jun  1 19:27:22 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.48 BogoMIPS (lpj=13578975)
Jun  1 19:27:22 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.45 BogoMIPS (lpj=13578913)
Jun  1 19:27:22 bluebuntu kernel: [    0.532028] Total of 4 processors activated (27157.81 BogoMIPS).
Jun  2 19:17:02 bluebuntu kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.33 BogoMIPS (lpj=13578676)
Jun  2 19:17:02 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.47 BogoMIPS (lpj=13578955)
Jun  2 19:17:02 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 6789.49 BogoMIPS (lpj=13578983)
Jun  2 19:17:02 bluebuntu kernel: [    0.004000] Calibrating delay using timer specific routine.. 967487.29 BogoMIPS (lpj=1934974585)
Jun  2 19:17:02 bluebuntu kernel: [    0.528027] Total of 4 processors activated (987855.59 BogoMIPS).

--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.txt"

[    0.000000] BIOS EBDA/lowmem at: 0009e000/0009e000
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.28-11-generic (buildd@crested) (gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #42-Ubuntu SMP Fri Apr 17 01:58:03 UTC 2009 (Ubuntu 2.6.28-11.42-generic)
[    0.000000] Command line: root=UUID=ad83e4e4-9339-4cd0-a4ab-962dbf93afc9 ro quiet splash 
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e400 (usable)
[    0.000000]  BIOS-e820: 000000000009e400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fe90000 (usable)
[    0.000000]  BIOS-e820: 000000007fe90000 - 000000007fee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007fee3000 - 000000007fef0000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007fef0000 - 000000007ff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.5 present.
[    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working it around.
[    0.000000] last_pfn = 0x7fe90 max_arch_pfn = 0x3ffffffff
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009e400 (usable)
[    0.000000]  modified: 000000000009e400 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000007fe90000 (usable)
[    0.000000]  modified: 000000007fe90000 - 000000007fee3000 (ACPI NVS)
[    0.000000]  modified: 000000007fee3000 - 000000007fef0000 (ACPI data)
[    0.000000]  modified: 000000007fef0000 - 000000007ff00000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] init_memory_mapping: 0000000000000000-000000007fe90000
[    0.000000]  0000000000 - 007fe00000 page 2M
[    0.000000]  007fe00000 - 007fe90000 page 4k
[    0.000000] kernel direct mapping tables up to 7fe90000 @ 10000-14000
[    0.000000] last_map_addr: 7fe90000 end: 7fe90000
[    0.000000] RAMDISK: 377a9000 - 37fef931
[    0.000000] ACPI: RSDP 000F8E10, 0014 (r0 IntelR)
[    0.000000] ACPI: RSDT 7FEE3000, 0038 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: FACP 7FEE3080, 0084 (r2 IntelR AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: DSDT 7FEE3140, 4FB1 (r1 INTELR AWRDACPI     1000 MSFT  3000000)
[    0.000000] ACPI: FACS 7FE90000, 0040
[    0.000000] ACPI: HPET 7FEE81C0, 0038 (r1 IntelR AWRDACPI 42302E31 AWRD       98)
[    0.000000] ACPI: MCFG 7FEE8200, 003C (r1 IntelR AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: APIC 7FEE8100, 0084 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: SSDT 7FEE8CE0, 0817 (r1  PmRef    CpuPm     3000 INTL 20041203)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (6 early reservations) ==> bootmem [0000000000 - 007fe90000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0000b854b0]    TEXT DATA BSS ==> [0000200000 - 0000b854b0]
[    0.000000]   #3 [00377a9000 - 0037fef931]          RAMDISK ==> [00377a9000 - 0037fef931]
[    0.000000]   #4 [000009e000 - 0000100000]    BIOS reserved ==> [000009e000 - 0000100000]
[    0.000000]   #5 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
[    0.000000] found SMP MP-table at [ffff8800000f4900] 000f4900
[    0.000000]  [ffffe20000000000-ffffe20001bfffff] PMD -> [ffff880001200000-ffff880002dfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x0007fe90
[    0.000000] On node 0 totalpages: 523806
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 2542 pages reserved
[    0.000000]   DMA zone: 1384 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7107 pages used for memmap
[    0.000000]   DMA32 zone: 512717 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 7ff00000:60100000)
[    0.000000] PERCPU: Allocating 69632 bytes of per cpu data
[    0.000000] NR_CPUS: 64, nr_cpu_ids: 4, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 514101
[    0.000000] Kernel command line: root=UUID=ad83e4e4-9339-4cd0-a4ab-962dbf93afc9 ro quiet splash 
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 3394.669 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.004000] allocated 20971520 bytes of page_cgroup
[    0.004000] please try cgroup_disable=memory option if you don't want
[    0.004000] Scanning for low memory corruption every 60 seconds
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] Calgary: detecting Calgary via BIOS EBDA area
[    0.004000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.004000] Memory: 2023688k/2095680k available (4760k kernel code, 456k absent, 70864k reserved, 2540k data, 536k init)
[    0.004000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6789.33 BogoMIPS (lpj=13578676)
[    0.004000] Security Framework initialized
[    0.004000] SELinux:  Disabled at boot.
[    0.004000] AppArmor: AppArmor initialized
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] Initializing cgroup subsys ns
[    0.004000] Initializing cgroup subsys cpuacct
[    0.004000] Initializing cgroup subsys memory
[    0.004000] Initializing cgroup subsys freezer
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] using mwait in idle threads.
[    0.004000] ACPI: Core revision 20080926
[    0.004000] ACPI: Checking initramfs for custom DSDT
[    0.215129] Setting APIC routing to flat
[    0.215454] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.255144] CPU0: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[    0.256001] Booting processor 1 APIC 0x3 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 6789.47 BogoMIPS (lpj=13578955)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 3
[    0.340372] CPU1: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[    0.340387] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.344054] Booting processor 2 APIC 0x2 ip 0x6000
[    0.004000] Initializing CPU#2
[    0.004000] Calibrating delay using timer specific routine.. 6789.49 BogoMIPS (lpj=13578983)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 2
[    0.432374] CPU2: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[    0.432389] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.436056] Booting processor 3 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#3
[    0.004000] Calibrating delay using timer specific routine.. 967487.29 BogoMIPS (lpj=1934974585)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.524425] CPU3: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[    0.524441] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.528026] Brought up 4 CPUs
[    0.528027] Total of 4 processors activated (987855.59 BogoMIPS).
[    0.528067] CPU0 attaching sched-domain:
[    0.528069]  domain 0: span 0,3 level MC
[    0.528070]   groups: 0 3
[    0.528072]   domain 1: span 0-3 level CPU
[    0.528073]    groups: 0,3 1-2
[    0.528076] CPU1 attaching sched-domain:
[    0.528077]  domain 0: span 1-2 level MC
[    0.528078]   groups: 1 2
[    0.528080]   domain 1: span 0-3 level CPU
[    0.528080]    groups: 1-2 0,3
[    0.528083] CPU2 attaching sched-domain:
[    0.528084]  domain 0: span 1-2 level MC
[    0.528085]   groups: 2 1
[    0.528086]   domain 1: span 0-3 level CPU
[    0.528087]    groups: 1-2 0,3
[    0.528090] CPU3 attaching sched-domain:
[    0.528090]  domain 0: span 0,3 level MC
[    0.528091]   groups: 3 0
[    0.528093]   domain 1: span 0-3 level CPU
[    0.528094]    groups: 0,3 1-2
[    0.528173] net_namespace: 1400 bytes
[    0.528173] Booting paravirtualized kernel on bare hardware
[    0.528179] Time: 19:16:50  Date: 06/02/09
[    0.528179] regulator: core version 0.5
[    0.528179] NET: Registered protocol family 16
[    0.528179] ACPI: bus type pci registered
[    0.528179] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.528179] PCI: MCFG area at e0000000 reserved in E820
[    0.534774] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.534775] PCI: Using configuration type 1 for base access
[    0.535163] ACPI: EC: Look up EC in DSDT
[    0.539873] ACPI: Interpreter enabled
[    0.539874] ACPI: (supports S0 S3 S4 S5)
[    0.539885] ACPI: Using IOAPIC for interrupt routing
[    0.543015] ACPI: No dock devices found.
[    0.543022] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.543070] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.543072] pci 0000:00:01.0: PME# disabled
[    0.543122] pci 0000:00:1a.0: reg 20 io port: [0xff00-0xff1f]
[    0.543167] pci 0000:00:1a.1: reg 20 io port: [0xfe00-0xfe1f]
[    0.543212] pci 0000:00:1a.2: reg 20 io port: [0xfd00-0xfd1f]
[    0.543249] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfdfff000-0xfdfff3ff]
[    0.543277] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.543280] pci 0000:00:1a.7: PME# disabled
[    0.543302] pci 0000:00:1b.0: reg 10 64bit mmio: [0xfdff4000-0xfdff7fff]
[    0.543322] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.543324] pci 0000:00:1b.0: PME# disabled
[    0.543352] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.543355] pci 0000:00:1c.0: PME# disabled
[    0.543389] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.543392] pci 0000:00:1c.5: PME# disabled
[    0.543430] pci 0000:00:1d.0: reg 20 io port: [0xfc00-0xfc1f]
[    0.543474] pci 0000:00:1d.1: reg 20 io port: [0xfb00-0xfb1f]
[    0.543519] pci 0000:00:1d.2: reg 20 io port: [0xfa00-0xfa1f]
[    0.543556] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfdffe000-0xfdffe3ff]
[    0.543584] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.543587] pci 0000:00:1d.7: PME# disabled
[    0.543668] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[    0.543670] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.543706] pci 0000:00:1f.2: reg 10 io port: [0xf900-0xf907]
[    0.543710] pci 0000:00:1f.2: reg 14 io port: [0xf800-0xf803]
[    0.543714] pci 0000:00:1f.2: reg 18 io port: [0xf700-0xf707]
[    0.543717] pci 0000:00:1f.2: reg 1c io port: [0xf600-0xf603]
[    0.543721] pci 0000:00:1f.2: reg 20 io port: [0xf500-0xf51f]
[    0.543724] pci 0000:00:1f.2: reg 24 32bit mmio: [0xfdffd000-0xfdffd7ff]
[    0.543734] pci 0000:00:1f.2: PME# supported from D3hot
[    0.543736] pci 0000:00:1f.2: PME# disabled
[    0.543755] pci 0000:00:1f.3: reg 10 64bit mmio: [0xfdffc000-0xfdffc0ff]
[    0.543764] pci 0000:00:1f.3: reg 20 io port: [0x500-0x51f]
[    0.543793] pci 0000:01:00.0: reg 10 32bit mmio: [0xfa000000-0xfaffffff]
[    0.543799] pci 0000:01:00.0: reg 14 64bit mmio: [0xd0000000-0xdfffffff]
[    0.543804] pci 0000:01:00.0: reg 1c 64bit mmio: [0xf8000000-0xf9ffffff]
[    0.543807] pci 0000:01:00.0: reg 24 io port: [0xdf00-0xdf7f]
[    0.543811] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.543842] pci 0000:00:01.0: bridge io port: [0xd000-0xdfff]
[    0.543843] pci 0000:00:01.0: bridge 32bit mmio: [0xf8000000-0xfbffffff]
[    0.543846] pci 0000:00:01.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.543873] pci 0000:00:1c.0: bridge 32bit mmio: [0x000000-0x0fffff]
[    0.543930] pci 0000:03:00.0: reg 10 64bit mmio: [0xfddf0000-0xfddfffff]
[    0.543964] pci 0000:03:00.0: PME# supported from D3hot D3cold
[    0.543968] pci 0000:03:00.0: PME# disabled
[    0.544014] pci 0000:00:1c.5: bridge 32bit mmio: [0xfdd00000-0xfddfffff]
[    0.544046] pci 0000:04:04.0: reg 10 32bit mmio: [0xfdee0000-0xfdeeffff]
[    0.544115] pci 0000:04:05.0: reg 10 32bit mmio: [0xfded0000-0xfdedffff]
[    0.544148] pci 0000:04:05.0: PME# supported from D3hot D3cold
[    0.544151] pci 0000:04:05.0: PME# disabled
[    0.544182] pci 0000:00:1e.0: transparent bridge
[    0.544185] pci 0000:00:1e.0: bridge 32bit mmio: [0xfde00000-0xfdefffff]
[    0.544199] bus 00 -> node 0
[    0.544203] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.544353] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.544420] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
[    0.544482] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.554062] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *7 9 10 11 12 14 15)
[    0.554138] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7 9 10 *11 12 14 15)
[    0.554215] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 7 9 10 11 12 *14 15)
[    0.554289] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 9 10 11 12 14 *15)
[    0.554364] ACPI: PCI Interrupt Link [LNKE] (IRQs 5 7 *9 10 11 12 14 15)
[    0.554438] ACPI: PCI Interrupt Link [LNKF] (IRQs 5 7 9 *10 11 12 14 15)
[    0.554512] ACPI: PCI Interrupt Link [LNK0] (IRQs *5 7 9 10 11 12 14 15)
[    0.554587] ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 9 10 11 12 14 *15)
[    0.554668] ACPI: WMI: Mapper loaded
[    0.554694] SCSI subsystem initialized
[    0.554694] libata version 3.00 loaded.
[    0.554694] usbcore: registered new interface driver usbfs
[    0.554694] usbcore: registered new interface driver hub
[    0.554694] usbcore: registered new device driver usb
[    0.554694] PCI: Using ACPI for IRQ routing
[    0.554694] pci 0000:00:1c.0: BAR 8: can't allocate resource
[    0.568009] Bluetooth: Core ver 2.13
[    0.568020] NET: Registered protocol family 31
[    0.568020] Bluetooth: HCI device and connection manager initialized
[    0.568020] Bluetooth: HCI socket layer initialized
[    0.568020] NET: Registered protocol family 8
[    0.568020] NET: Registered protocol family 20
[    0.568027] NetLabel: Initializing
[    0.568029] NetLabel:  domain hash size = 128
[    0.568030] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.568040] NetLabel:  unlabeled traffic allowed by default
[    0.568072] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.568074] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.580045] AppArmor: AppArmor Filesystem Enabled
[    0.584007] Switched to high resolution mode on CPU 0
[    0.584469] Switched to high resolution mode on CPU 3
[    0.584953] Switched to high resolution mode on CPU 2
[    0.584957] Switched to high resolution mode on CPU 1
[    0.592022] pnp: PnP ACPI init
[    0.592029] ACPI: bus type pnp registered
[    0.593529] pnp: PnP ACPI: found 12 devices
[    0.593530] ACPI: ACPI bus type pnp unregistered
[    0.593535] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.593537] system 00:01: ioport range 0x300-0x37f has been reserved
[    0.593538] system 00:01: ioport range 0x290-0x297 has been reserved
[    0.593539] system 00:01: ioport range 0x300-0x30f has been reserved
[    0.593540] system 00:01: ioport range 0xa00-0xa0f has been reserved
[    0.593541] system 00:01: ioport range 0x880-0x88f has been reserved
[    0.593545] system 00:08: ioport range 0x400-0x4bf could not be reserved
[    0.593549] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
[    0.593552] system 00:0b: iomem range 0xf0000-0xfffff could not be reserved
[    0.593553] system 00:0b: iomem range 0x7ff00000-0x7fffffff has been reserved
[    0.593554] system 00:0b: iomem range 0xfed00000-0xfed000ff has been reserved
[    0.593556] system 00:0b: iomem range 0x7fe90000-0x7fefffff could not be reserved
[    0.593557] system 00:0b: iomem range 0x0-0x9ffff could not be reserved
[    0.593558] system 00:0b: iomem range 0x100000-0x7fe8ffff could not be reserved
[    0.593560] system 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.593561] system 00:0b: iomem range 0xfed13000-0xfed1ffff has been reserved
[    0.593562] system 00:0b: iomem range 0xfed20000-0xfed9ffff has been reserved
[    0.593564] system 00:0b: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.593565] system 00:0b: iomem range 0xffb00000-0xffb7ffff has been reserved
[    0.593566] system 00:0b: iomem range 0xfff00000-0xffffffff has been reserved
[    0.593567] system 00:0b: iomem range 0xe0000-0xeffff has been reserved
[    0.598154] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.598155] pci 0000:00:01.0:   IO window: 0xd000-0xdfff
[    0.598157] pci 0000:00:01.0:   MEM window: 0xf8000000-0xfbffffff
[    0.598159] pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    0.598161] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.598162] pci 0000:00:1c.0:   IO window: disabled
[    0.598165] pci 0000:00:1c.0:   MEM window: disabled
[    0.598167] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.598171] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:03
[    0.598172] pci 0000:00:1c.5:   IO window: disabled
[    0.598174] pci 0000:00:1c.5:   MEM window: 0xfdd00000-0xfddfffff
[    0.598177] pci 0000:00:1c.5:   PREFETCH window: disabled
[    0.598180] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:04
[    0.598181] pci 0000:00:1e.0:   IO window: disabled
[    0.598184] pci 0000:00:1e.0:   MEM window: 0xfde00000-0xfdefffff
[    0.598186] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.598194] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.598195] pci 0000:00:01.0: setting latency timer to 64
[    0.598199] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.598203] pci 0000:00:1c.0: setting latency timer to 64
[    0.598207] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.598210] pci 0000:00:1c.5: setting latency timer to 64
[    0.598213] pci 0000:00:1e.0: setting latency timer to 64
[    0.598215] bus: 00 index 0 io port: [0x00-0xffff]
[    0.598217] bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
[    0.598218] bus: 01 index 0 io port: [0xd000-0xdfff]
[    0.598219] bus: 01 index 1 mmio: [0xf8000000-0xfbffffff]
[    0.598220] bus: 01 index 2 mmio: [0xd0000000-0xdfffffff]
[    0.598220] bus: 01 index 3 mmio: [0x0-0x0]
[    0.598221] bus: 02 index 0 mmio: [0x0-0x0]
[    0.598222] bus: 02 index 1 mmio: [0x0-0xfffff]
[    0.598223] bus: 02 index 2 mmio: [0x0-0x0]
[    0.598224] bus: 02 index 3 mmio: [0x0-0x0]
[    0.598225] bus: 03 index 0 mmio: [0x0-0x0]
[    0.598225] bus: 03 index 1 mmio: [0xfdd00000-0xfddfffff]
[    0.598226] bus: 03 index 2 mmio: [0x0-0x0]
[    0.598227] bus: 03 index 3 mmio: [0x0-0x0]
[    0.598228] bus: 04 index 0 mmio: [0x0-0x0]
[    0.598229] bus: 04 index 1 mmio: [0xfde00000-0xfdefffff]
[    0.598230] bus: 04 index 2 mmio: [0x0-0x0]
[    0.598230] bus: 04 index 3 io port: [0x00-0xffff]
[    0.598231] bus: 04 index 4 mmio: [0x000000-0xffffffffffffffff]
[    0.598236] NET: Registered protocol family 2
[    0.632057] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.632233] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.633125] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.633398] TCP: Hash tables configured (established 262144 bind 65536)
[    0.633400] TCP reno registered
[    0.644105] NET: Registered protocol family 1
[    0.644179] checking if image is initramfs... it is
[    1.070464] Freeing initrd memory: 8474k freed
[    1.072683] audit: initializing netlink socket (disabled)
[    1.072698] type=2000 audit(1243970205.072:1): initialized
[    1.077553] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.078296] VFS: Disk quotas dquot_6.5.1
[    1.078328] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.078653] fuse init (API version 7.10)
[    1.078700] msgmni has been set to 3970
[    1.078818] alg: No test for stdrng (krng)
[    1.078832] io scheduler noop registered
[    1.078833] io scheduler anticipatory registered
[    1.078834] io scheduler deadline registered
[    1.078860] io scheduler cfq registered (default)
[    1.079090] pci 0000:01:00.0: Boot video device
[    1.080986] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    1.081003] pcieport-driver 0000:00:01.0: found MSI capability
[    1.081015] pcieport-driver 0000:00:01.0: irq 2303 for MSI/MSI-X
[    1.081020] pci_express 0000:00:01.0:pcie00: allocate port service
[    1.081028] pci_express 0000:00:01.0:pcie03: allocate port service
[    1.081053] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    1.081083] pcieport-driver 0000:00:1c.0: found MSI capability
[    1.081098] pcieport-driver 0000:00:1c.0: irq 2302 for MSI/MSI-X
[    1.081106] pci_express 0000:00:1c.0:pcie00: allocate port service
[    1.081112] pci_express 0000:00:1c.0:pcie02: allocate port service
[    1.081119] pci_express 0000:00:1c.0:pcie03: allocate port service
[    1.081154] pcieport-driver 0000:00:1c.5: setting latency timer to 64
[    1.081176] pcieport-driver 0000:00:1c.5: found MSI capability
[    1.081192] pcieport-driver 0000:00:1c.5: irq 2301 for MSI/MSI-X
[    1.081199] pci_express 0000:00:1c.5:pcie00: allocate port service
[    1.081205] pci_express 0000:00:1c.5:pcie02: allocate port service
[    1.081211] pci_express 0000:00:1c.5:pcie03: allocate port service
[    1.081250] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.081386] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.081464] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.081465] ACPI: Power Button (FF) [PWRF]
[    1.081490] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    1.081491] ACPI: Power Button (CM) [PWRB]
[    1.081519] fan PNP0C0B:00: registered as cooling_device0
[    1.081530] ACPI: Fan [FAN] (on)
[    1.081921] ACPI: SSDT 7FEE8280, 028B (r1  PmRef  Cpu0Ist     3000 INTL 20061109)
[    1.082066] processor ACPI_CPU:00: registered as cooling_device1
[    1.082325] ACPI: SSDT 7FEE87A0, 01B3 (r1  PmRef  Cpu1Ist     3000 INTL 20061109)
[    1.082463] processor ACPI_CPU:01: registered as cooling_device2
[    1.082722] ACPI: SSDT 7FEE8960, 01B3 (r1  PmRef  Cpu2Ist     3000 INTL 20061109)
[    1.082859] processor ACPI_CPU:02: registered as cooling_device3
[    1.083118] ACPI: SSDT 7FEE8B20, 01B3 (r1  PmRef  Cpu3Ist     3000 INTL 20061109)
[    1.083255] processor ACPI_CPU:03: registered as cooling_device4
[    1.084815] thermal LNXTHERM:01: registered as thermal_zone0
[    1.084980] ACPI: Thermal Zone [THRM] (27 C)
[    1.113655] Linux agpgart interface v0.103
[    1.113660] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[    1.114177] brd: module loaded
[    1.114341] loop: module loaded
[    1.114377] Fixed MDIO Bus: probed
[    1.114379] PPP generic driver version 2.4.2
[    1.114410] input: Macintosh mouse button emulation as /devices/virtual/input/input2
[    1.114424] Driver 'sd' needs updating - please use bus_type methods
[    1.114428] Driver 'sr' needs updating - please use bus_type methods
[    1.114448] ahci 0000:00:1f.2: version 3.0
[    1.114457] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.114483] ahci 0000:00:1f.2: irq 2300 for MSI/MSI-X
[    1.114532] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    1.114534] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pmp pio slum part ems 
[    1.114536] ahci 0000:00:1f.2: setting latency timer to 64
[    1.114778] scsi0 : ahci
[    1.114837] scsi1 : ahci
[    1.114886] scsi2 : ahci
[    1.114932] scsi3 : ahci
[    1.114986] scsi4 : ahci
[    1.115031] scsi5 : ahci
[    1.115102] ata1: SATA max UDMA/133 abar m2048@0xfdffd000 port 0xfdffd100 irq 2300
[    1.115104] ata2: SATA max UDMA/133 abar m2048@0xfdffd000 port 0xfdffd180 irq 2300
[    1.115106] ata3: SATA max UDMA/133 abar m2048@0xfdffd000 port 0xfdffd200 irq 2300
[    1.115107] ata4: SATA max UDMA/133 abar m2048@0xfdffd000 port 0xfdffd280 irq 2300
[    1.115108] ata5: SATA max UDMA/133 abar m2048@0xfdffd000 port 0xfdffd300 irq 2300
[    1.115110] ata6: SATA max UDMA/133 irq_stat 0x00000040, connection status changed irq 2300
[    1.596012] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.602320] ata1.00: ATA-7: SAMSUNG HD103UJ, 1AA01113, max UDMA7
[    1.602322] ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.608701] ata1.00: configured for UDMA/133
[    2.108013] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.114312] ata2.00: ATA-7: SAMSUNG HD103UJ, 1AA01113, max UDMA7
[    2.114315] ata2.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.120686] ata2.00: configured for UDMA/133
[    2.456017] ata3: SATA link down (SStatus 0 SControl 300)
[    2.792017] ata4: SATA link down (SStatus 0 SControl 300)
[    3.128017] ata5: SATA link down (SStatus 0 SControl 300)
[    4.032009] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.032693] ata6.00: ATAPI: TSSTcorp CDDVDW SH-S223F, SB00, max UDMA/100, ATAPI AN
[    4.033639] ata6.00: configured for UDMA/100
[    4.048096] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
[    4.048142] sd 0:0:0:0: [sda] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
[    4.048151] sd 0:0:0:0: [sda] Write Protect is off
[    4.048152] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.048166] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.048202] sd 0:0:0:0: [sda] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
[    4.048210] sd 0:0:0:0: [sda] Write Protect is off
[    4.048211] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.048224] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.048226]  sda: sda1 < sda5 sda6 sda7 sda8 > sda2 sda3
[    4.089571] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.089597] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.089631] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
[    4.089673] sd 1:0:0:0: [sdb] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
[    4.089681] sd 1:0:0:0: [sdb] Write Protect is off
[    4.089682] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    4.089696] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.089721] sd 1:0:0:0: [sdb] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
[    4.089729] sd 1:0:0:0: [sdb] Write Protect is off
[    4.089730] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    4.089745] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.089747]  sdb: sdb1 < sdb5 sdb6 sdb7 sdb8 > sdb2
[    4.118250] sd 1:0:0:0: [sdb] Attached SCSI disk
[    4.118282] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    4.118802] scsi 5:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-S223F  SB00 PQ: 0 ANSI: 5
[    4.122022] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    4.122025] Uniform CD-ROM driver Revision: 3.20
[    4.122105] sr 5:0:0:0: Attached scsi CD-ROM sr0
[    4.122124] sr 5:0:0:0: Attached scsi generic sg2 type 5
[    4.122446] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.122461] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.122472] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    4.122475] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    4.122506] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    4.126412] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    4.126422] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfdfff000
[    4.140028] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    4.140075] usb usb1: configuration #1 chosen from 1 choice
[    4.140095] hub 1-0:1.0: USB hub found
[    4.140099] hub 1-0:1.0: 6 ports detected
[    4.140164] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    4.140170] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.140171] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.140192] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    4.144078] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    4.144085] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfdffe000
[    4.156010] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.156053] usb usb2: configuration #1 chosen from 1 choice
[    4.156071] hub 2-0:1.0: USB hub found
[    4.156075] hub 2-0:1.0: 6 ports detected
[    4.156131] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.156138] uhci_hcd: USB Universal Host Controller Interface driver
[    4.156157] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.156162] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.156163] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.156184] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    4.156206] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000ff00
[    4.156245] usb usb3: configuration #1 chosen from 1 choice
[    4.156257] hub 3-0:1.0: USB hub found
[    4.156260] hub 3-0:1.0: 2 ports detected
[    4.156303] uhci_hcd 0000:00:1a.1: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.156306] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    4.156308] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.156328] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    4.156345] uhci_hcd 0000:00:1a.1: irq 18, io base 0x0000fe00
[    4.156381] usb usb4: configuration #1 chosen from 1 choice
[    4.156393] hub 4-0:1.0: USB hub found
[    4.156396] hub 4-0:1.0: 2 ports detected
[    4.156439] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    4.156442] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    4.156444] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    4.156467] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    4.156489] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000fd00
[    4.156533] usb usb5: configuration #1 chosen from 1 choice
[    4.156545] hub 5-0:1.0: USB hub found
[    4.156550] hub 5-0:1.0: 2 ports detected
[    4.156593] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    4.156596] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.156598] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.156619] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    4.156636] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000fc00
[    4.156671] usb usb6: configuration #1 chosen from 1 choice
[    4.156684] hub 6-0:1.0: USB hub found
[    4.156687] hub 6-0:1.0: 2 ports detected
[    4.156731] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    4.156735] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.156736] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.156759] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    4.156776] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000fb00
[    4.156813] usb usb7: configuration #1 chosen from 1 choice
[    4.156825] hub 7-0:1.0: USB hub found
[    4.156828] hub 7-0:1.0: 2 ports detected
[    4.156871] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.156874] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.156876] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.156899] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    4.156915] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000fa00
[    4.156952] usb usb8: configuration #1 chosen from 1 choice
[    4.156964] hub 8-0:1.0: USB hub found
[    4.156967] hub 8-0:1.0: 2 ports detected
[    4.157034] usbcore: registered new interface driver libusual
[    4.157051] usbcore: registered new interface driver usbserial
[    4.157056] USB Serial support registered for generic
[    4.157064] usbcore: registered new interface driver usbserial_generic
[    4.157065] usbserial: USB Serial Driver core
[    4.157087] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    4.157088] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    4.157387] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.168538] mice: PS/2 mouse device common for all mice
[    4.204553] rtc_cmos 00:04: RTC can wake from S4
[    4.204578] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    4.204601] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    4.204632] device-mapper: uevent: version 1.0.3
[    4.204700] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    4.204815] device-mapper: multipath: version 1.0.5 loaded
[    4.204817] device-mapper: multipath round-robin: version 1.0.0 loaded
[    4.204971] cpuidle: using governor ladder
[    4.204972] cpuidle: using governor menu
[    4.205199] TCP cubic registered
[    4.205233] NET: Registered protocol family 10
[    4.205434] lo: Disabled Privacy Extensions
[    4.205582] NET: Registered protocol family 17
[    4.205591] Bluetooth: L2CAP ver 2.11
[    4.205592] Bluetooth: L2CAP socket layer initialized
[    4.205594] Bluetooth: SCO (Voice Link) ver 0.6
[    4.205594] Bluetooth: SCO socket layer initialized
[    4.205625] Bluetooth: RFCOMM socket layer initialized
[    4.205628] Bluetooth: RFCOMM TTY layer initialized
[    4.205630] Bluetooth: RFCOMM ver 1.10
[    4.206041] registered taskstats version 1
[    4.206114]   Magic number: 13:882:292
[    4.206135] tty tty25: hash matches
[    4.206178] rtc_cmos 00:04: setting system clock to 2009-06-02 19:16:54 UTC (1243970214)
[    4.206183] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    4.206183] EDD information not available.
[    4.206205] Freeing unused kernel memory: 536k freed
[    4.206315] Write protecting the kernel read-only data: 6708k
[    4.302682] md: linear personality registered for level -1
[    4.303773] md: multipath personality registered for level -4
[    4.304752] md: raid0 personality registered for level 0
[    4.306312] md: raid1 personality registered for level 1
[    4.307180] xor: automatically using best checksumming function: generic_sse
[    4.323993]    generic_sse: 12647.000 MB/sec
[    4.323994] xor: using function: generic_sse (12647.000 MB/sec)
[    4.324582] async_tx: api initialized (async)
[    4.392004] raid6: int64x1   2716 MB/s
[    4.460002] raid6: int64x2   3735 MB/s
[    4.528002] raid6: int64x4   2839 MB/s
[    4.596016] raid6: int64x8   2566 MB/s
[    4.663994] raid6: sse2x1    5510 MB/s
[    4.731994] raid6: sse2x2    6107 MB/s
[    4.800017] raid6: sse2x4   10099 MB/s
[    4.800017] raid6: using algorithm sse2x4 (10099 MB/s)
[    4.800017] md: raid6 personality registered for level 6
[    4.800017] md: raid5 personality registered for level 5
[    4.800017] md: raid4 personality registered for level 4
[    4.803587] md: raid10 personality registered for level 10
[    4.835297] tg3.c:v3.94 (August 14, 2008)
[    4.835307] tg3 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    4.835313] tg3 0000:03:00.0: setting latency timer to 64
[    4.913039] usb 1-6: new high speed USB device using ehci_hcd and address 2
[    4.999375] md: bind<sdb6>
[    5.034810] md: bind<sda6>
[    5.042147] md0: setting max_sectors to 128, segment boundary to 32767
[    5.042149] raid0: looking at sda6
[    5.042150] raid0:   comparing sda6(67119424) with sda6(67119424)
[    5.042151] raid0:   END
[    5.042152] raid0:   ==> UNIQUE
[    5.042153] raid0: 1 zones
[    5.042153] raid0: looking at sdb6
[    5.042154] raid0:   comparing sdb6(67119424) with sda6(67119424)
[    5.042156] raid0:   EQUAL
[    5.042156] raid0: FINAL 1 zones
[    5.042157] raid0: done.
[    5.042158] raid0 : md_size is 134238848 blocks.
[    5.042159] raid0 : conf->hash_spacing is 134238848 blocks.
[    5.042160] raid0 : nb_zone is 1.
[    5.042160] raid0 : Allocating 8 bytes for hash.
[    5.043047]  md0: unknown partition table
[    5.048430] usb 1-6: configuration #1 chosen from 1 choice
[    5.048529] hub 1-6:1.0: USB hub found
[    5.048637] hub 1-6:1.0: 1 port detected
[    5.321642] usb 1-6.1: new low speed USB device using ehci_hcd and address 3
[    5.372615] eth0: Tigon3 [partno(BCM95751) rev b002 PHY(5787)] (PCI Express) 10/100/1000Base-T Ethernet 00:1c:25:da:10:33
[    5.372617] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
[    5.372618] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    5.372634] tg3 0000:04:05.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    5.420656] eth1: Tigon3 [partno(BCM95788) rev 3003 PHY(5705)] (PCI:33MHz:32-bit) 10/100/1000Base-T Ethernet 00:1c:25:da:10:32
[    5.420658] eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[1]
[    5.420659] eth1: dma_rwctrl[763f0000] dma_mask[32-bit]
[    5.436682] usb 1-6.1: configuration #1 chosen from 1 choice
[    5.440059] usbcore: registered new interface driver hiddev
[    5.440104] usbcore: registered new interface driver usbhid
[    5.440105] usbhid: v2.6:USB HID core driver
[    5.444708] input: Microsft Microsoft Wireless Desktop Receiver 3.1 as /devices/pci0000:00/0000:00:1a.7/usb1/1-6/1-6.1/1-6.1:1.0/input/input3
[    5.476559] microsoft 0003:045E:00F9.0001: input,hidraw0: USB HID v1.11 Keyboard [Microsft Microsoft Wireless Desktop Receiver 3.1] on usb-0000:00:1a.7-6.1/input0
[    5.490264] microsoft 0003:045E:00F9.0002: fixing up Microsoft Wireless Receiver Model 1028 report descriptor
[    5.496995] input: Microsft Microsoft Wireless Desktop Receiver 3.1 as /devices/pci0000:00/0000:00:1a.7/usb1/1-6/1-6.1/1-6.1:1.1/input/input4
[    5.533048] microsoft 0003:045E:00F9.0002: input,hidraw1: USB HID v1.11 Mouse [Microsft Microsoft Wireless Desktop Receiver 3.1] on usb-0000:00:1a.7-6.1/input1
[    5.589690] PM: Starting manual resume from disk
[    5.589691] PM: Resume from partition 8:5
[    5.589692] PM: Checking hibernation image.
[    5.589788] PM: Resume from disk failed.
[    5.601153] EXT4-fs: barriers enabled
[    5.614103] kjournald2 starting.  Commit interval 5 seconds
[    5.614116] EXT4-fs: delayed allocation enabled
[    5.614118] EXT4-fs: file extents enabled
[    5.614462] EXT4-fs: mballoc enabled
[    5.614464] EXT4-fs: mounted filesystem with ordered data mode.
[    6.462952] udev: starting version 141
[    6.524515] EDAC MC: Ver: 2.1.0 Apr 17 2009
[    7.091192] nvidia: module license 'NVIDIA' taints kernel.
[    7.094617] ath_hal: 0.9.18.0 (AR5210, AR5211, AR5212, RF5111, RF5112, RF2413, RF5413)
[    7.341838] nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.341842] nvidia 0000:01:00.0: setting latency timer to 64
[    7.341978] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  180.44  Tue Mar 24 05:46:32 PST 2009
[    7.350620] iTCO_vendor_support: vendor-support=0
[    7.353840] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    7.353900] iTCO_wdt: Found a ICH9R TCO device (Version=2, TCOBASE=0x0460)
[    7.353938] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    7.358231] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    7.377852] EDAC MC0: Giving out device to 'x38_edac' 'x38': DEV 0000:00:00.0
[    7.383475] wlan: 0.9.4
[    7.386446] ath_pci: 0.9.4
[    7.386474] ath_pci 0000:04:04.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    7.501022] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    7.501071] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    7.534424] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
[    7.997365] ath_rate_sample: 1.2 (0.9.4)
[    7.997863] wifi0: 11b rates: 1Mbps 2Mbps 5.5Mbps 11Mbps
[    7.997867] wifi0: 11g rates: 1Mbps 2Mbps 5.5Mbps 11Mbps 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
[    7.997872] wifi0: turboG rates: 6Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
[    7.997875] wifi0: H/W encryption support: WEP AES AES_CCM TKIP
[    7.997877] wifi0: mac 7.9 phy 4.5 radio 5.6
[    7.997879] wifi0: Use hw queue 1 for WME_AC_BE traffic
[    7.997880] wifi0: Use hw queue 0 for WME_AC_BK traffic
[    7.997881] wifi0: Use hw queue 2 for WME_AC_VI traffic
[    7.997882] wifi0: Use hw queue 3 for WME_AC_VO traffic
[    7.997883] wifi0: Use hw queue 8 for CAB traffic
[    7.997884] wifi0: Use hw queue 9 for beacons
[    8.000045] wifi0: Atheros 5212: mem=0xfdee0000, irq=18
[    8.106744] lp: driver loaded but no devices found
[    8.120064] f71882fg: Found F71882FG chip at 0x290, revision 32
[    8.122487] coretemp coretemp.0: Using relative temperature scale!
[    8.122509] coretemp coretemp.1: Using relative temperature scale!
[    8.122533] coretemp coretemp.2: Using relative temperature scale!
[    8.122556] coretemp coretemp.3: Using relative temperature scale!
[    8.150355] Adding 8393888k swap on /dev/sda5.  Priority:-1 extents:1 across:8393888k
[    8.153970] Adding 8393888k swap on /dev/sdb5.  Priority:-2 extents:1 across:8393888k
[    8.670609] EXT4 FS on sda7, internal journal on sda7:8
[    9.257617] EXT4-fs: barriers enabled
[    9.257762] kjournald2 starting.  Commit interval 5 seconds
[    9.257892] EXT4 FS on dm-4, internal journal on dm-4:8
[    9.257895] EXT4-fs: delayed allocation enabled
[    9.257896] EXT4-fs: file extents enabled
[    9.258619] EXT4-fs: mballoc enabled
[    9.258621] EXT4-fs: mounted filesystem with ordered data mode.
[    9.286147] EXT4-fs: barriers enabled
[    9.297561] kjournald2 starting.  Commit interval 5 seconds
[    9.298293] EXT4 FS on dm-2, internal journal on dm-2:8
[    9.298296] EXT4-fs: delayed allocation enabled
[    9.298297] EXT4-fs: file extents enabled
[    9.301906] EXT4-fs: mballoc enabled
[    9.301909] EXT4-fs: mounted filesystem with ordered data mode.
[    9.331242] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[    9.332235] SGI XFS Quota Management subsystem
[    9.332505] Filesystem "md0": Disabling barriers, trial barrier write failed
[    9.332606] XFS mounting filesystem md0
[    9.429559] Ending clean XFS mount for filesystem: md0
[    9.429924] Filesystem "dm-3": Disabling barriers, trial barrier write failed
[    9.479173] XFS mounting filesystem dm-3
[    9.575308] Ending clean XFS mount for filesystem: dm-3
[    9.575688] Filesystem "dm-5": Disabling barriers, trial barrier write failed
[    9.575792] XFS mounting filesystem dm-5
[    9.668283] Ending clean XFS mount for filesystem: dm-5
[    9.669551] EXT4-fs: barriers enabled
[    9.684209] kjournald2 starting.  Commit interval 5 seconds
[    9.684341] EXT4 FS on dm-1, internal journal on dm-1:8
[    9.684343] EXT4-fs: delayed allocation enabled
[    9.684344] EXT4-fs: file extents enabled
[    9.685044] EXT4-fs: mballoc enabled
[    9.685046] EXT4-fs: mounted filesystem with ordered data mode.
[    9.690978] EXT4-fs: barriers enabled
[    9.700043] kjournald2 starting.  Commit interval 5 seconds
[    9.700228] EXT4 FS on dm-0, internal journal on dm-0:8
[    9.700230] EXT4-fs: delayed allocation enabled
[    9.700232] EXT4-fs: file extents enabled
[    9.700390] EXT4-fs: mballoc enabled
[    9.700392] EXT4-fs: mounted filesystem with ordered data mode.
[   10.415755] type=1505 audit(1243981020.707:2): operation="profile_load" name="/usr/share/gdm/guest-session/Xsession" name2="default" pid=2317
[   10.437282] type=1505 audit(1243981020.727:3): operation="profile_load" name="/sbin/dhclient-script" name2="default" pid=2321
[   10.437338] type=1505 audit(1243981020.727:4): operation="profile_load" name="/sbin/dhclient3" name2="default" pid=2321
[   10.437359] type=1505 audit(1243981020.727:5): operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" name2="default" pid=2321
[   10.437378] type=1505 audit(1243981020.727:6): operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" name2="default" pid=2321
[   10.497521] type=1505 audit(1243981020.791:7): operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" name2="default" pid=2326
[   10.497606] type=1505 audit(1243981020.791:8): operation="profile_load" name="/usr/sbin/cupsd" name2="default" pid=2326
[   10.530385] type=1505 audit(1243981020.823:9): operation="profile_load" name="/usr/sbin/dhcpd3" name2="default" pid=2330
[   10.543560] type=1505 audit(1243981020.835:10): operation="profile_load" name="/usr/sbin/tcpdump" name2="default" pid=2334
[   13.477889] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   13.477891] Bluetooth: BNEP filters: protocol multicast
[   13.492241] Bridge firewalling registered
[   14.356206] warning: `dhcpd3' uses 32-bit capabilities (legacy support in use)
[   14.472421] JBD: barrier-based sync failed on dm-0:8 - disabling barriers
[   16.692785] ppdev: user-space parallel port driver
[   21.017205] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   21.030320] tg3 0000:03:00.0: irq 2299 for MSI/MSI-X
[   21.092749] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   21.653265] JBD: barrier-based sync failed on dm-4:8 - disabling barriers
[   21.792284] JBD: barrier-based sync failed on dm-1:8 - disabling barriers
[   31.860518] ath0: no IPv6 routers present

--jI8keyz6grp/JLjh--
