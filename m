Return-Path: <linux-kernel-owner+w=401wt.eu-S1761487AbXHDAlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761487AbXHDAlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 20:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756615AbXHDAlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 20:41:24 -0400
Received: from dsl081-085-152.lax1.dsl.speakeasy.net ([64.81.85.152]:48241
	"EHLO moonbase.phunq.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753762AbXHDAlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 20:41:23 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: Distributed storage.
Date: Fri, 3 Aug 2007 17:41:18 -0700
User-Agent: KMail/1.9.5
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <20070731171347.GA14267@2ka.mipt.ru>
In-Reply-To: <20070731171347.GA14267@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708031741.18404.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Evgeniy,

Nit alert:

On Tuesday 31 July 2007 10:13, Evgeniy Polyakov wrote:
>     * storage can be formed on top of remote nodes and be exported
> 	simultaneously (iSCSI is peer-to-peer only, NBD requires device
> 	mapper and is synchronous)

In fact, NBD has nothing to do with device mapper.  I use it as a 
physical target underneath ddraid (a device mapper plugin) just like I 
would use your DST if it proves out.

Regards,

Daniel
