Return-Path: <linux-kernel-owner+w=401wt.eu-S1161434AbXDWLXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161434AbXDWLXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 07:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161429AbXDWLXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 07:23:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:64966 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161411AbXDWLXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 07:23:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: schwidefsky@de.ibm.com
Subject: Re: [PATCH 7/8] Kconfig: silicon backplane dependency.
Date: Mon, 23 Apr 2007 13:22:36 +0200
User-Agent: KMail/1.9.6
Cc: Michael Buesch <mb@bu3sch.de>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, akpm@linux-foundation.org,
       linville@tuxdriver.com
References: <20070420113505.GH3738@skybase> <200704221146.11439.mb@bu3sch.de> <1177327011.5984.10.camel@localhost>
In-Reply-To: <1177327011.5984.10.camel@localhost>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704231322.36970.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX184LcJoHN9aJfaHkRcPsasX200TIbPAk1LeuM5
 Oe6n3K7pxSeWJhJmlTfB+FlXswM27MnlHlRKg69Y/piUR73ozS
 6li1tw5yEN/FnOBi7B9CA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 April 2007, Martin Schwidefsky wrote:
> The current Kconfig code does not check all select statements if they
> can be enabled before allowing the config option that does the select.
> So the rule for using select statements is that the depends line of the
> config option that selects another config option needs to be at least as
> restrictive as the depends line of the selected option. Hence I'll add
> the HAS_IOMEM depends to B44 as well. Okay ?

Isn't B44 already behind a WIRELESS or IEEE80211 or similar option that
can't be selected on s390?

	Arnd <><
