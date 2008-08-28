Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbYH1RJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbYH1RJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbYH1RJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:09:41 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58089 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbYH1RJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:09:41 -0400
Date: Thu, 28 Aug 2008 12:09:38 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Andreas Gruenbacher <agruen@suse.de>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [patch] file capabilities: Add no_file_caps switch
Message-ID: <20080828170938.GA13286@us.ibm.com>
References: <200808262057.51606.agruen@suse.de> <200808271729.18220.agruen@suse.de> <20080827160439.GA12085@us.ibm.com> <200808271857.48651.agruen@suse.de> <20080827185845.GA25669@us.ibm.com> <48B6C5B1.1050109@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B6C5B1.1050109@kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew G. Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Sorry to get to this late.
>
> I very much prefer this patch over the resuscitation of the cap_set_pg()
> code.
>
> [I would also like to advocate we combine it with making
> CONFIG_SECURITY_FILE_CAPABILITIES=y the default config option.]

I certainly don't mind that, but I would expect complaints about this
unless the default boot option were 'n'.

Do you think it's worth sending as a separate trivial patch?  Then if
people object to one both changes won't be held up.

(Anyway that's what I'll do right now)

-serge
