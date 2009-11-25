Return-Path: <linux-kernel-owner+w=401wt.eu-S1758600AbZKYLNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbZKYLNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 06:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbZKYLNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 06:13:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49229 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752243AbZKYLNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 06:13:31 -0500
Date: Wed, 25 Nov 2009 11:13:37 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
Cc: "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>,
       "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
Subject: Re: [PATCHv2 3/3] Define critical regulators as always_on
Message-ID: <20091125111336.GF17420@opensource.wolfsonmicro.com>
References: <1259143495-9480-1-git-send-email-ext-juha.1.keski-saari@nokia.com> <1259143495-9480-4-git-send-email-ext-juha.1.keski-saari@nokia.com> <20091125101407.GA17420@opensource.wolfsonmicro.com> <1259144999.10122.3.camel@keskisaa-workstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259144999.10122.3.camel@keskisaa-workstation>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 12:29:59PM +0200, Juha Keski-Saari wrote:

> +		case TWL4030_REG_VINTDIG:
> +			c->always_on = true;
> +			break;

One other thing I noticed having seen the MFD series - is this going to
build without the separate MFD patch you've posted?
