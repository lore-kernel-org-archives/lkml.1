Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbYAGI7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbYAGI7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 03:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYAGI7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 03:59:16 -0500
Received: from mout0.freenet.de ([195.4.92.90]:54798 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbYAGI7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 03:59:15 -0500
Message-ID: <4781E9DE.6070308@de.ibm.com>
Date: Mon, 07 Jan 2008 09:59:10 +0100
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       Carsten Otte <cotte@de.ibm.com>
Subject: Re: [PATCH] xip: fix get_zeroed_page with __GFP_HIGHMEM
References: <20071225132126.GA4800@APFDCB5C>
In-Reply-To: <20071225132126.GA4800@APFDCB5C>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Warning: de.ibm.com is listed at abuse.rfc-ignorant.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Akinobu Mita wrote:
> The use of get_zeroed_page() with __GFP_HIGHMEM is invalid.
> Use alloc_page() with __GFP_ZERO instead of invalid get_zeroed_page().
*Ouch*

Acked-by: Carsten Otte <cotte@de.ibm.com>
