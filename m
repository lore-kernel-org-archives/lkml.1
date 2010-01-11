Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442Ab0AKNMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab0AKNMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 08:12:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237Ab0AKNMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 08:12:12 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:17964 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab0AKNMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 08:12:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HWQHGJRMl9lO2arC0LbJ3p8+UzZ38iD60n6Nm5hc+z1sirLSO65PstXfX0ohsJtAKG
         DW0WVfgOtnsoPFBc7j2LMDXR2ht4p/6OQZtskxqVZaelr5D2pEsPkjxE6rT+i0XtWywE
         THwFc2hcig/i64TtGJxUCb5iUCj6QhInrBJ8c=
MIME-Version: 1.0
In-Reply-To: <omZ8aBZReyD.A.0FG.xMlSLB@chimera>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
	 <omZ8aBZReyD.A.0FG.xMlSLB@chimera>
Date: Mon, 11 Jan 2010 08:12:09 -0500
Message-ID: <6041d2001001110512p58e84103n53cf3729b28a5313@mail.gmail.com>
Subject: Re: [Bug #15037] BUG during shutdown - bisected to commit e2912009
From: Marc Dionne <marc.c.dionne@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Xiaotian Feng <dfeng@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 10, 2010 at 5:32 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15037
> Subject         : BUG during shutdown - bisected to commit e2912009
> Submitter       : Marc Dionne <marc.c.dionne@gmail.com>
> Date            : 2010-01-02 0:27 (9 days old)
> References      : http://marc.info/?l=linux-kernel&m=126239207631034&w=4
> Handled-By      : Xiaotian Feng <dfeng@redhat.com>
> Patch           : http://patchwork.kernel.org/patch/71537/

I verified that the BUG still occurs with current git.
The referenced patch does fix the issue for me, but it hasn't made its
way into mainline yet.

Thanks,
Marc
