Return-Path: <linux-kernel-owner+w=401wt.eu-S1758518AbYHZLIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518AbYHZLIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 07:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757037AbYHZLHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 07:07:54 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:15809 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834AbYHZLHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 07:07:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JsY680FG46+UbnVGWanNVWUfOdblHDHai9+UGbp6RpRrfcWjKhbEtWDyiQt7B1h4jf
         a/FEILdqsJP9PPZJAfyYxBz6UciqT4Hy+LIeEFjKuweeGiFpoGsgtqIaCWUT1mo2hQuZ
         7VMi9vxZn/PwmxH7CoYhQg228ECdlL5ZJiEw0=
Date: Tue, 26 Aug 2008 11:07:46 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Denys Fedoryshchenko <denys@visp.net.lb>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: loaded router, excessive getnstimeofday in oprofile
Message-ID: <20080826110746.GC2609@ff.dom.local>
References: <20080826095126.GA2609@ff.dom.local> <200808261329.53741.denys@visp.net.lb> <20080826104717.GB2609@ff.dom.local> <200808261349.09820.denys@visp.net.lb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808261349.09820.denys@visp.net.lb>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 01:49:09PM +0300, Denys Fedoryshchenko wrote:
> On Tuesday 26 August 2008, Jarek Poplawski wrote:
> > The question is if you really need so exact shaping at a cost of
> > higher system load.
> Thats maybe another reason to have your patch in mainline :-)

We should be first sure when it's really needed.

> I will try it today with this case, if it will help.
> 
> Maybe it can be optional, and enabled via kernel parameter and /sys , so it 
> can be useful in case of crashes when TSC used and when timer is too slow.
> Because it is not so useful just to disable hrtimers completely, if you need 
> them for some other task...

Maybe it could be enough to use current parameters like: "highres=off"
according to Documentation/kernel-parameters.txt?

Jarek P.
