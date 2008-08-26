Return-Path: <linux-kernel-owner+w=401wt.eu-S1758163AbYHZKus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbYHZKus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 06:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbYHZKui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 06:50:38 -0400
Received: from relay2.globalproof.net ([194.146.153.25]:56550 "EHLO
	relay2.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbYHZKuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 06:50:37 -0400
From: Denys Fedoryshchenko <denys@visp.net.lb>
Organization: Virtual ISP
To: Jarek Poplawski <jarkao2@gmail.com>
Subject: Re: loaded router, excessive getnstimeofday in oprofile
Date: Tue, 26 Aug 2008 13:49:09 +0300
User-Agent: KMail/1.9.9
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080826095126.GA2609@ff.dom.local> <200808261329.53741.denys@visp.net.lb> <20080826104717.GB2609@ff.dom.local>
In-Reply-To: <20080826104717.GB2609@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808261349.09820.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 August 2008, Jarek Poplawski wrote:
> The question is if you really need so exact shaping at a cost of
> higher system load.
Thats maybe another reason to have your patch in mainline :-)
I will try it today with this case, if it will help.

Maybe it can be optional, and enabled via kernel parameter and /sys , so it 
can be useful in case of crashes when TSC used and when timer is too slow.
Because it is not so useful just to disable hrtimers completely, if you need 
them for some other task...

