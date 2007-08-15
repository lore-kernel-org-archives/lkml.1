Return-Path: <linux-kernel-owner+w=401wt.eu-S934335AbXHOTMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934335AbXHOTMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 15:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbXHOTMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 15:12:03 -0400
Received: from smtp115.sbc.mail.re3.yahoo.com ([66.196.96.88]:38586 "HELO
	smtp115.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756167AbXHOTMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 15:12:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4mWFZQLOnGv0pHkw/1NLAz+prmPArcBq5zlAidFh2SN8+rwKid/WzFDubcI0MIRpCMXZlDZkksLUGphg2Oayvhp5t928FsdBaKTS9sQVcnyJQ0+is5eRf4V56kGo54BYQEt8NV1FwHojvTxsqkelA7hgHbOvK3y2/ICBE7PotKE=  ;
X-YMail-OSG: .BGhiEgVM1nKOZp9ipuKPFBQvlWqRY6qXQUrXBKMTk322j2h5UV30u4CDhKcm96EIzCVy8XPwg--
From: David Brownell <david-b@pacbell.net>
To: Stuart_Hayes@dell.com
Subject: Re: [linux-usb-devel] EHCI Regression in 2.6.23-rc2
Date: Wed, 15 Aug 2007 12:12:03 -0700
User-Agent: KMail/1.9.6
Cc: linux-usb-devel@lists.sourceforge.net, webmaster@dragonslave.de,
       greg@kroah.com, linux-kernel@vger.kernel.org
References: <200708101045.57166.dex@dragonslave.de> <DFEF91B22ED07447AB6AA4B237F913F9B18E7F@ausx3mpc125.aus.amer.dell.com> <DFEF91B22ED07447AB6AA4B237F913F9B18E9B@ausx3mpc125.aus.amer.dell.com>
In-Reply-To: <DFEF91B22ED07447AB6AA4B237F913F9B18E9B@ausx3mpc125.aus.amer.dell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200708151212.04065.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 August 2007, Stuart_Hayes@dell.com wrote:
> So... I still think blacklisting the VIA controllers from this CPU
> frequency stuff is the best option.  

Sadly, yes.  My negative impression of VIA quality is confirmed,
yet again...

Please make sure the comments in your blacklist code describe both
of the chip bugs you've observed.


> 	It is unlikely that any real issues 
> will be seen during CPU frequency transitions with these controllers
> anyway, because they claim to cache 8 uframes of the periodic schedule.
 
I'd not be so sure.  But if there are such issues, we can wait
for problem reports.

- Dvae


