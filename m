Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbXFXXk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbXFXXk3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 19:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbXFXXkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 19:40:20 -0400
Received: from web36605.mail.mud.yahoo.com ([209.191.85.22]:40144 "HELO
	web36605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751418AbXFXXkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 19:40:19 -0400
X-YMail-OSG: xyZ1sGsVM1lCx_Xn12C_ad4OTJQ1oP5ZA6Ci_sQtar0r2SZxoL0OMXGo8etATi8IL9QpM.6XnA--
X-RocketYMMF: rancidfat
Date: Sun, 24 Jun 2007 16:40:18 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH][RFC] security: Convert LSM into a static interface
To: Chris Wright <chrisw@sous-sol.org>, James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
In-Reply-To: <20070624220903.GB3723@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <181834.50504.qm@web36605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Chris Wright <chrisw@sous-sol.org> wrote:

> * James Morris (jmorris@namei.org) wrote:
> > -module_param_named(disable, capability_disable, int, 0);
> > -MODULE_PARM_DESC(disable, "To disable capabilities module set disable =
> 1");
> > +
> > +static int __init capability_disable_setup(char *str)
> > +{
> > +	capability_disable = simple_strtol(str, NULL, 0);
> > +	return 1;
> > +}
> > +__setup("capability_disable=", capability_disable_setup);
> 
> This changes the command line argument.  Other than that and a some
> sanity testing I'll take this.

Sigh. So much for my schedule.

So, for planning purposes, when ought I expect to have to start
dealing with this?



Casey Schaufler
casey@schaufler-ca.com
