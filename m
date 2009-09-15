Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbZIOSj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbZIOSj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 14:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758275AbZIOSjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 14:39:24 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:48490 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066AbZIOSjX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 14:39:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=v4OwViJF1bbfGkGSKvRbgyxv1Z7MiC5WsbcVAlMyPo1nXmOtOV1fyKuAkECE06bwUA
         KdSY9XONhoiYXAsGqhMZub0kpOzYgq1IEoor0XckSnHKnfMPyZT0zesYhRNuKJt/LqeX
         eDXnGO6323UKbL1WshnoXwgA+jvAihJQsce6U=
MIME-Version: 1.0
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C501F10104@exchange.ZeugmaSystems.local>
References: <DDFD17CC94A9BD49A82147DDF7D545C501F0FF17@exchange.ZeugmaSystems.local>
	 <200909151127.10697.bjorn.helgaas@hp.com>
	 <DDFD17CC94A9BD49A82147DDF7D545C501F100E4@exchange.ZeugmaSystems.local>
	 <12c511ca0909151100ne3841b7l7af5bffb977d6d9b@mail.gmail.com>
	 <DDFD17CC94A9BD49A82147DDF7D545C501F100EB@exchange.ZeugmaSystems.local>
	 <57C9024A16AD2D4C97DC78E552063EA3E05DBC6E@orsmsx505.amr.corp.intel.com>
	 <DDFD17CC94A9BD49A82147DDF7D545C501F10104@exchange.ZeugmaSystems.local>
Date: Tue, 15 Sep 2009 11:39:26 -0700
X-Google-Sender-Auth: 79f10b67c78c7d2e
Message-ID: <12c511ca0909151139w400256d1t84dad5fa9e1ab3a2@mail.gmail.com>
Subject: Re: [PATCH] cleanup legacy console_print function
From: Tony Luck <tony.luck@intel.com>
To: Anirban Sinha <ASinha@zeugmasystems.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-ia64@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 11:25 AM, Anirban Sinha
<ASinha@zeugmasystems.com> wrote:
>  arch/ia64/kernel/head.S    |    1 -
>  arch/ia64/kernel/head.h    |    1 -
>  arch/ia64/kernel/process.c |    2 +-
>  3 files changed, 1 insertions(+), 3 deletions(-)

The diffstat doesn't match the patch (doesn't include a change to
process.c) ... but the patch itself is OK.

Acked-by: Tony Luck <tony.luck@intel.com>
