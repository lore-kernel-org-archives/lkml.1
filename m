Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab0CAQxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 11:53:37 -0500
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:52712 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751033Ab0CAQxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 11:53:36 -0500
From: Frans Pop <elendil@planet.nl>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH RFC] kconfig: place git SHA1 in .config output if in git tree
Date: Mon, 1 Mar 2010 17:53:32 +0100
User-Agent: KMail/1.9.9
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, mingo@elte.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
References: <20100301042249.GA12289@linux.vnet.ibm.com> <10f740e81003010210k3de9851fuf9f67f55b08af4f1@mail.gmail.com> <20100301162733.GB6758@linux.vnet.ibm.com>
In-Reply-To: <20100301162733.GB6758@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003011753.34299.elendil@planet.nl>
X-OriginalArrivalTime: 01 Mar 2010 16:53:35.0164 (UTC) FILETIME=[BB76D7C0:01CAB95F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 March 2010, Paul E. McKenney wrote:
> Here is the updated patch.  Thoughts?

AFAICT that still won't work with KBUILD_OUTPUT as you're not passing the 
source tree directory to the script. So it will default to "." and when 
KBUILD_OUTPUT is used that is not the source tree but the target tree (and 
thus not under git).

Cheers,
FJP
