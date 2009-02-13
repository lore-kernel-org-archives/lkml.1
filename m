Return-Path: <linux-kernel-owner+w=401wt.eu-S1758728AbZBMIxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728AbZBMIxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 03:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbZBMIxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 03:53:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:2433 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbZBMIxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 03:53:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,201,1233561600"; 
   d="scan'208";a="665324116"
Subject: Re: [PATCH 1/1] ipw2200, fix ipw io functions
From: Zhu Yi <yi.zhu@intel.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       James Ketrenos <jketreno@linux.intel.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>
In-Reply-To: <49952DFD.4050903@gmail.com>
References: <1234474180-910-1-git-send-email-jirislaby@gmail.com>
	 <1234486180.6354.203.camel@debian>  <49952DFD.4050903@gmail.com>
Content-Type: text/plain
Date: Fri, 13 Feb 2009 16:50:51 +0800
Message-Id: <1234515051.6354.204.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-13 at 16:23 +0800, Jiri Slaby wrote:
> On 02/13/2009 01:49 AM, Zhu Yi wrote:
> > On Fri, 2009-02-13 at 05:29 +0800, Jiri Slaby wrote:
> >>  /* alias to 8-bit direct read (low 4K of SRAM/regs), with debug
> >> wrapper */
> >> -#define ipw_read8(ipw, ofs) __ipw_read8(__FILE__, __LINE__, ipw, ofs)
> >> +#define ipw_read8(ipw, ofs) ({ \
> >> +       IPW_DEBUG_IO("%s %d: read_direct8(0x%08X)\n", __FILE__, __LINE__, \
> >> +                       (u32)(ofs)); \
> >> +       _ipw_read8(ipw, ofs); \
> >> +})
> > 
> > Please put a do {} while(0) for this and some of below macros as well.
> 
> This is impossible, reads need to return a value...

Right.

Acked-by: Zhu Yi <yi.zhu@intel.com>

Thanks,
-yi

