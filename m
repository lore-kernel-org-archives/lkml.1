Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbYLOTWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbYLOTWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 14:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbYLOTWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 14:22:08 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:57253 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbYLOTWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 14:22:07 -0500
Message-ID: <4946AE5C.9040207@oracle.com>
Date: Mon, 15 Dec 2008 11:22:04 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       paul.moore@hp.com, netdev <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for December 15 (netlabel)
References: <20081216020642.fc1007d9.sfr@canb.auug.org.au>
In-Reply-To: <20081216020642.fc1007d9.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4946AE51.0179:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

netlabel_domainhash fails to build when IPV6 is not enabled:

build-r7133.out:/local/linsrc/linux-next-20081215/net/netlabel/netlabel_domainhash.c:527: error: implicit declaration of function 'netlbl_af6list_foreach_rcu'
build-r7133.out:/local/linsrc/linux-next-20081215/net/netlabel/netlabel_domainhash.c:528: error: expected ';' before 'goto'
build-r7133.out:make[3]: *** [net/netlabel/netlabel_domainhash.o] Error 1


~Randy

