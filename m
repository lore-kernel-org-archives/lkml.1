Return-Path: <linux-kernel-owner+w=401wt.eu-S1758976AbYFFO1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976AbYFFO1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 10:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbYFFO1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 10:27:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:23725 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbYFFO1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 10:27:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E6FBJVenYkeBpDxBLP3VXMYoQpWh5nde7pM9qk0hS4dxETxEPTfOrDbXZxq4IzNdJx
         EScP7J8hYb7pYVzDWCJtW7l/X9JEJcr+mKBE1xFg0/zSLMMHGXfvLPeyYMH9TECXrZ4C
         cDWjHw2v1QQhp7nrGcZC7J+mR/BOAoW53mJB8=
Date: Fri, 6 Jun 2008 10:27:40 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: ??ric Piel <Eric.Piel@tremplin-utc.net>
Cc: Andrew Morton <akpm@osdl.org>, pavel@ucw.cz,
       Arjan van de Ven <arjan@infradead.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Yan Burman <burman.yan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       HWMON <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 2.6.25.4]  hwmon: HP Mobile Data Protection System 3D
	ACPI driver -- please review!
Message-ID: <20080606102636.ZZRA012@mailhub.coreip.homeip.net>
References: <1212235533.3815.5.camel@localhost> <4846EBF5.2030406@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4846EBF5.2030406@tremplin-utc.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 04, 2008 at 09:24:37PM +0200, ??ric Piel wrote:
> Hello,
> We haven't received any review for this driver since last week's post by
> Yan :-( That's why I'm adding explicitly as receivers of this email all
> the people who have reviewed the first two previous takes. Apologies for
> the possible multiple receptions.
> 
> It would be _really really kind_ if some of you could take some time and
> comment (or simply ACK ;-) ) this code. It adds support for hardware
> which can be found in mostly every HP Compaq laptop less than three
> years old. It's quite worthy.
> 

I would recommend converting the input piece to input_polled_device
instead of managing the polling thread by yourselves.

-- 
Dmitry
