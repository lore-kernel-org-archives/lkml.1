Return-Path: <linux-kernel-owner+w=401wt.eu-S933113AbZAQUs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113AbZAQUs6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 15:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763953AbZAQUss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 15:48:48 -0500
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:48207 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1763080AbZAQUss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 15:48:48 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:Reply-To:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gcYcQRADp/z7xPlNh++fcxmJBc2DvBJh53obzdrJSUHSiRl8O6w5cMor0QWyZ/htw7GHSJRFMNlOYe/AHvkXgRThWeWPW8+hAukFGTUIPXfSMtFrVbRu/XPOY7fOZfh1uqdOxFiXA+IuAdrmUYu5MbPijNvlQ292ArJKfMMu6RI=  ;
X-YMail-OSG: 9wvs01QVM1ko3DZWA8Evhvv9AHJ11RCz1sc5zFYJHG2Z0d.ym3bzjMkCmVgmr7nzrb6MbvJNDYnDm4xrLVSWK5255OMUEa_04uHVdroWqIfw0GlMsaDiXGT8wWfsGMp1JmWQ6onPppSPX7CmM2YUyUmeITH6Bl.nbdrDAPqr_Ga9NAHC4p_6z4Y3GTpD
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
Reply-To: dbrownell@users.sourceforge.net
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/6] omap iommu: tlb and pagetable primitives
Date: Sat, 17 Jan 2009 12:48:45 -0800
User-Agent: KMail/1.9.10
Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org
References: <20090116083003.18344.38307.stgit@oreo.research.nokia.com> <20090116083709.18344.74524.stgit@oreo.research.nokia.com> <20090117160608.GA12341@n2100.arm.linux.org.uk>
In-Reply-To: <20090117160608.GA12341@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200901171248.45757.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 January 2009, Russell King - ARM Linux wrote:
> > +#ifdef DEBUG_VERBOSE
> > +             dev_dbg(obj->dev, "%s:\ta new pte:%p\n", __func__, iopte);
> > +#endif
> 
> Not sure wrapping these in DEBUG_VERBOSE is necessary.  dev_dbg() is a
> no-op unless DEBUG is defined.

Use dev_vdbg() to get the "NOP unless VERBOSE is set" semantics.

