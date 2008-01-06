Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbYAFVuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbYAFVuB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 16:50:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbYAFVtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 16:49:51 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:53334 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbYAFVtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 16:49:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=llCH1OOfG8clVJbjgd+w3+uxVZyv3SRn+iBJjjux0wGhgpSKtn/5mA1Mf/lC9SvKGsE9ZWO7a8wAmWkk1gJkWLOmb5m7WqRNAThKHRSHC4rBXYCi4w2nMS0W/hIdIay1qb7nqQp1p3479F4eGUoQdWtUxkArOKED9luI3gfZ5+A=
Message-ID: <b4292e150801061349v3b54ffc0vfed75dbcb83daf9b@mail.gmail.com>
Date: Sun, 6 Jan 2008 19:49:49 -0200
From: "Adolfo R. Brandes" <arbrandes@gmail.com>
To: "=?ISO-8859-1?Q?Bj=F6rn_Steinbrink?=" <B.Steinbrink@gmx.de>
Subject: Re: forcedeth: MAC-address reversed on resume from suspend
Cc: "Adrian Bunk" <bunk@kernel.org>, "Andreas Mohr" <andi@lisas.de>,
       "Richard Jonsson" <richie@coderworld.net>, linux-kernel@vger.kernel.org,
       "Ayaz Abdulla" <aabdulla@nvidia.com>, jgarzik@pobox.com,
       netdev@vger.kernel.org
In-Reply-To: <20080104034357.GA2113@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <477BFC71.7090002@coderworld.net>
	 <20080102214843.GA19224@rhlx01.hs-esslingen.de>
	 <20080102234209.GA10831@does.not.exist>
	 <20080104034357.GA2113@atjola.homenet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 I have this forcedeth MAC address reversal problem when suspending
on 2 distinct boxes.  I can confirm Steinbrink's patch fixes the
problem on only one of them:

00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev f3)

 On the other one the problem persists:

00:14.0 Bridge: nVidia Corporation MCP51 Ethernet Controller (rev a1)

Thanks,
Adolfo
