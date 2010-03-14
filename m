Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab0CNFS5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 00:18:57 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:37016 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab0CNFSy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 00:18:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=Etp9Wwiq90tORvM4ScW50WfJJjtkZ9+j02iERtPtNxuj8vNnpf1IvlD2iJbR61GvPR
         ehCaA/eYRHK0p6iza33PavfPVPWSerjIXpHJ7Xwmo5Y0OaI7DQFPybs8kl5WoT3ACASQ
         e6LNOp0nGfY/Z3oJGMOKJshQft+/z8PwieQvI=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20100312205537.GA1091@us.ibm.com>
References: <20100312205537.GA1091@us.ibm.com>
Date: Sun, 14 Mar 2010 06:18:50 +0100
Message-ID: <cfd18e0f1003132118y21bd71band2d07ae85c8d4c9@mail.gmail.com>
Subject: Re: [PATCH] Define CAP_SYSLOG
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: James Morris <jmorris@namei.org>, lkml <linux-kernel@vger.kernel.org>,
       SELinux <selinux@tycho.nsa.gov>, linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@epoch.ncsc.mil>,
       Kees Cook <kees.cook@canonical.com>, Andrew Morgan <morgan@kernel.org>,
       "Christopher J. PeBenito" <cpebenito@tresys.com>,
       Eric Paris <eparis@parisplace.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There is one downside to this patch:  If some site or distro currently
> has syslogd/whatever running as a non-root user with cap_sys_admin+pe,
> then it will need to be changed to run with cap_syslog+pe.  I don't
> know if there are such sites, or if that concern means we should take
> a different approach to introducing this change, or simply refuse this
> change.

*If* this is a problem, would the way to address it not be to permit
syslog if the caller has *either* CAP_SYS_ADMIN or CAP_SYSLOG? (The
only weakness I see in this idea is that it fails to lighten the
hugely overlaoded CAP_SYS_ADMIN.)

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/
