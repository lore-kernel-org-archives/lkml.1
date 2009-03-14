Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbZCNHv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbZCNHv1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 03:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbZCNHvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 03:51:18 -0400
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:58357 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751057AbZCNHvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 03:51:17 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-17.arcor-online.net 328DA3B2B3E
From: Prakash Punnoor <prakash@punnoor.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [patch 069/114] PCI: dont enable too many HT MSI mappings
Date: Sat, 14 Mar 2009 08:53:38 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@hobbes.lan>
References: <20090314010937.416083662@mini.kroah.org> <20090314011041.598193480@mini.kroah.org>
In-Reply-To: <20090314011041.598193480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903140853.41893.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Samstag 14 März 2009 02:10:46 Greg KH wrote:
> 2.6.28-stable review patch.  If anyone has any objections, please let us
> know.
>
> ------------------
>
> From: Yinghai Lu <yinghai@kernel.org>
>
> commit 1dec6b054dd1fc780e18b815068bf5677409eb2d upstream.

You also want to add 

  commit  7726c3308a92b4a4c3bd059059498fca0e6f8e48
  commit  6a958d5b28e4a180458e0d319d2e4bb5c4b7da3e

otherwise this one doesn't help me much - or drop this one completely for a 
while. To fix my system, 7726c3308a92b4a4c3bd059059498fca0e6f8e48 alone 
(without 1dec6b054dd1fc780e18b815068bf5677409eb2d) should be enough.

Regards,

Prakash
