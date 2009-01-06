Return-Path: <linux-kernel-owner+w=401wt.eu-S1752780AbZAFKVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbZAFKVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 05:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbZAFKVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 05:21:30 -0500
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:40159 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750899AbZAFKV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 05:21:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:Reply-To:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=6p43HlRCboBc4Jb9Tksr3oGOLdnLDIKJ/R+aWZhajr3cvPBs70Wg2OB8B4KRM+O7S/Oe2B80NGDVH9kfap2/FV3GTnakmBEKPJdtApV7ybuj8ZPnHs3UMpeJGnTWaUycidVQc5e7Owfz4WIkpy6znqFh5mVKEG2Cih4JuWBXVxY=  ;
X-YMail-OSG: hoGKXFUVM1kmXCFVoYFlrYfHO7H_lJ3o4jjaOyD38v84WJfJQoZp_HoXYGaOLPW7Ug05Ej0lXZ25f3cWcayveP2zkQSciQYtSI2Uy.KtrBmU_7fmVEs7c6iwLp9STzGbSh8RdyA1EkmQzvhmuhAc2vWa
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
Reply-To: dbrownell@users.sourceforge.net
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.28-rc7] regulator: catch some registration errors
Date: Tue, 6 Jan 2009 02:21:26 -0800
User-Agent: KMail/1.9.10
Cc: lrg@slimlogic.co.uk, lkml <linux-kernel@vger.kernel.org>
References: <200812011335.43551.david-b@pacbell.net> <200901051545.04912.david-b@pacbell.net> <20090106101050.GB6783@sirena.org.uk>
In-Reply-To: <20090106101050.GB6783@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901060221.26614.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 January 2009, Mark Brown wrote:
> On Mon, Jan 05, 2009 at 03:45:04PM -0800, David Brownell wrote:
> 
> > When someone writes a cpufreq driver that uses the
> > regulator framework, they can arrange to provide the
> > relevant "struct device *" to make that work neatly.
> 
> I'm fairly sure it's been mentioned before but there's some already, for
> example:
> 
>	[ Long URL for your i.MX3 cpufreq driver elided ] 

Right, and what's keeping you from providing a "struct device *"
for that to use?

