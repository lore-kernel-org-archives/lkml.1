Return-Path: <linux-kernel-owner+w=401wt.eu-S1759209AbYC0TQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209AbYC0TQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 15:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757067AbYC0TQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 15:16:22 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:33922 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756800AbYC0TQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 15:16:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FdNBDPhEzjbp620aOnmFnrIrjq3Tz0mjR5JjNg6DGyUm0NpyuIsslHGDt4j1kHfHspsI4M0gPfhQhGaEFBXZLDoPnDznC8Ws9dIkHcCPdGLlzpn0H7cy1d0LTzKmLCnG4OxsYJzUXcuImlijPtl7cxOHdrRBIZQoPnMBs9MsRhY=  ;
X-YMail-OSG: o24BJWwVM1mWxsmNvne.k41JKnHuw6ABLBzlUR4sZJE47z05Wg7.ouc3NBb8cBWMHJycXm6_tg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: some minor issues with 2.6.25-rc6-git7-default
Date: Thu, 27 Mar 2008 12:16:18 -0700
User-Agent: KMail/1.9.6
Cc: devzero@web.de, "Rafael J. Wysocki" <rjw@sisk.pl>,
       alan@lxorguk.ukuu.org.uk, greg@kroah.com, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
References: <213294492@web.de> <20080326131346.39efee07.randy.dunlap@oracle.com>
In-Reply-To: <20080326131346.39efee07.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803271216.18672.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 March 2008, Randy Dunlap wrote:
> 
> > > uh, "known problem": multiple rtc drivers are being run.
> > > 
> > > I don't really understand why we haven't been able to fix this - there have
> > > been numerous reports..
> > 
> > i will take a closer look to determine how/when this happens.
> 
> I thought that David B. sent a (Kconfig ?) patch for this...

He did.  In fact, one with a weak "nudge users away from this"
and then a stronger "don't effing allow it" update.  That's all
in the MM tree.

- Dave

