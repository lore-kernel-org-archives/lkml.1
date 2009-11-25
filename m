Return-Path: <linux-kernel-owner+w=401wt.eu-S1758730AbZKYLhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730AbZKYLhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 06:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758701AbZKYLhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 06:37:51 -0500
Received: from smtp.nokia.com ([192.100.105.134]:24778 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758691AbZKYLhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 06:37:50 -0500
Subject: Re: [PATCHv2 3/3] Define critical regulators as always_on
From: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
To: ext Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>,
       "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
In-Reply-To: <20091125111336.GF17420@opensource.wolfsonmicro.com>
References: <1259143495-9480-1-git-send-email-ext-juha.1.keski-saari@nokia.com>
	 <1259143495-9480-4-git-send-email-ext-juha.1.keski-saari@nokia.com>
	 <20091125101407.GA17420@opensource.wolfsonmicro.com>
	 <1259144999.10122.3.camel@keskisaa-workstation>
	 <20091125111336.GF17420@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Nov 2009 13:36:39 +0200
Message-ID: <1259148999.10122.25.camel@keskisaa-workstation>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Nov 2009 11:36:41.0632 (UTC) FILETIME=[8EDC1A00:01CA6DC3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-25 at 12:13 +0100, ext Mark Brown wrote:
> On Wed, Nov 25, 2009 at 12:29:59PM +0200, Juha Keski-Saari wrote:
> 
> > +		case TWL4030_REG_VINTDIG:
> > +			c->always_on = true;
> > +			break;
> 
> One other thing I noticed having seen the MFD series - is this going to
> build without the separate MFD patch you've posted?

Yes, the changes to twl4030-regulator.c compile without the changes the
MFD patch set makes to twl4030-core.c and twl4030.h

