Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbYAGBrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbYAGBrB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 20:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbYAGBqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 20:46:43 -0500
Received: from mail.gmx.net ([213.165.64.20]:40051 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752875AbYAGBqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 20:46:42 -0500
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX19kwUo4X9ZkBVGLYralGiop2Bsg+W32jgEtHb/BLi
	lPIgWb6Pl6DYAj
Date: Mon, 7 Jan 2008 02:46:38 +0100
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: "Adolfo R. Brandes" <arbrandes@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>, Andreas Mohr <andi@lisas.de>,
       Richard Jonsson <richie@coderworld.net>, linux-kernel@vger.kernel.org,
       Ayaz Abdulla <aabdulla@nvidia.com>, jgarzik@pobox.com,
       netdev@vger.kernel.org
Subject: Re: forcedeth: MAC-address reversed on resume from suspend
Message-ID: <20080107014638.GA4170@atjola.homenet>
References: <477BFC71.7090002@coderworld.net> <20080102214843.GA19224@rhlx01.hs-esslingen.de> <20080102234209.GA10831@does.not.exist> <20080104034357.GA2113@atjola.homenet> <b4292e150801061349v3b54ffc0vfed75dbcb83daf9b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b4292e150801061349v3b54ffc0vfed75dbcb83daf9b@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-12-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008.01.06 19:49:49 -0200, Adolfo R. Brandes wrote:
>  I have this forcedeth MAC address reversal problem when suspending
> on 2 distinct boxes.  I can confirm Steinbrink's patch fixes the
> problem on only one of them:
> 
> 00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev f3)
> 
>  On the other one the problem persists:
> 
> 00:14.0 Bridge: nVidia Corporation MCP51 Ethernet Controller (rev a1)

Thanks. Leaves me pretty clueless though. Especially since it worked for
Richard, who also has a MCP51. In a private mail, you said that you had
hardcoded the mac address in the source. Any chance that you applied the
patch on your modified sources and didn't get it right?

thanks,
Björn
