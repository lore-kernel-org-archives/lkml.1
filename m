Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbYAQIdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbYAQIdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 03:33:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbYAQIc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 03:32:58 -0500
Received: from smtp114.sbc.mail.mud.yahoo.com ([68.142.198.213]:38353 "HELO
	smtp114.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750865AbYAQIc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 03:32:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=p0Be23StD5xjeJORNMCpW+fTE7VautOCQea1cWM+dpe8sAHgagE2bNt/fHJGatJ7awMLCUASl6mAYZ/EuNZfRqyEdw6H2QQgb14U9jkwTDfJtrjZFZaVkWUkhOMg+G/JqICbfXuKIsupqVGwvIg9JG/uy08rpr+tgY7bcCJSOj4=  ;
X-YMail-OSG: 8.Tr6TMVM1n_I7V7pBtk9ObcH5zbh40ctI4IP.O5WT3P_zt_DLRSuqf.5ywzUoQtT3BJSsYPdg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: 2.6.23-git Kconfig regression
Date: Thu, 17 Jan 2008 00:32:54 -0800
User-Agent: KMail/1.9.6
Cc: "Roman Zippel" <zippel@linux-m68k.org>,
       "lkml" <linux-kernel@vger.kernel.org>,
       "Randy Dunlap" <rdunlap@xenotime.net>
References: <20071020012245.9B3FB23A5F7@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <200801161602.01557.david-b@pacbell.net> <478F1CDD.76E4.0078.0@novell.com>
In-Reply-To: <478F1CDD.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801170032.54788.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 January 2008, Jan Beulich wrote:
> >This stuff isn't for "distro" kernels; it's for embedded
> >environments of the "only this hardware exists" sort.
> >Space matters, and having small code matters.  Nobody has
> >been interested enough in an "embedded distro" model to
> >provide patches enabling such stuff.
> 
> Why not make the whole thing depend on EMBEDDED then?

Because while its design center is small systems, there's
actually no technical dependency there.  The Kconfig for
EMBEDDED also says it's for disabling or tweaking standard
settings ... ergo, not *adding* subsystems or drivers.

Oddly enough, most things that work on small systems can
also be used on bigger ones.  :)

- Dave
