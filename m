Return-Path: <linux-kernel-owner+w=401wt.eu-S1759982AbZDIKsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982AbZDIKsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbZDIKsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:48:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58945 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbZDIKsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:48:21 -0400
Date: Thu, 9 Apr 2009 12:50:23 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>,
       Jan Knutar <jk-lkml@sci.fi>
Subject: Re: SSD and IO schedulers
Message-ID: <20090409105023.GA5936@fancy-poultry.org>
Reply-To: linux-kernel@vger.kernel.org
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Corrado Zoccolo <czoccolo@gmail.com>,
	=?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>,
	Jan Knutar <jk-lkml@sci.fi>
References: <4dcf7d360901301355l7ed26a5aob7ef6d79d9607b6b@mail.gmail.com> <20090204004003.26068f72@werewolf.home> <200902071858.40146.jk-lkml@sci.fi> <4e5e476b0904081218i29871702qc8bacb680c51ec2c@mail.gmail.com> <20090408195610.GA5447@fancy-poultry.org> <4e5e476b0904081318h4445556am1a6b0a49c6175719@mail.gmail.com> <20090409103322.GA5382@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090409103322.GA5382@fancy-poultry.org>
Organization: private site
User-Agent: Mutt/1.5.19+20090405 (GNU/Linux)
X-Provags-ID: V01U2FsdGVkX18kHxAwG6dgeRuPvwv/ycMdBaijwHmlapUKhj/
 d4GNHT30qQ1QjF1m+J91K3MFsszUzNbl0LtmhdWTpf/brbyo8r
 RA4GMmfG5vSEEodxWfd2C8KisgAQs3ja67d6UZS81I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.04.2009, Heinz Diehl wrote: 

[....]

Quoting myself, I did copy in the wrong results from another machine,
sorry for that! The fsync-tester results were the right ones, though.

Here are the correct ones for the bonnie++ runs (the overall results doesn't differ 
significantly either):


CFQ

Version 1.01d       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
wildsau       4004M 69133  48 67512  12 21810   8 94426  59 129977 13  1163   3
                    ------Sequential Create------ --------Random Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
    16:100000:16/64   589   8 +++++ +++  1211   6   544   7 +++++ +++   421   4


DL

Version 1.01d       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
wildsau       4004M 71112  46 66155  15 22001   8 95132  62 130416 14  1191   3
                    ------Sequential Create------ --------Random Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
    16:100000:16/64   565   9 +++++ +++  1339   6   561   8 +++++ +++   430   4

