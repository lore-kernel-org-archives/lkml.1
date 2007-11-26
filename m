Return-Path: <linux-kernel-owner+w=401wt.eu-S1758173AbXKZRFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbXKZRFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 12:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbXKZRFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 12:05:34 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:21925 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbXKZRFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 12:05:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=M67OgCU/5nG/LTqZCc7MTE6CrKXd0g2yhShAPBONCcunPaGB4WJBCSK80y+8FxJe+t5em7u4eM94r/snPrhQTVtRtuduCDMYtioXUQ4sMQclS3Hju2RcJHXdAz1t5+4gYKxOYXl9eqqO3GNA7FoxeDLV97kwtOwRxygsOPg6Rao=
Message-ID: <671c20540711260905p11249695x9e3999bf25f3cf2@mail.gmail.com>
Date: Mon, 26 Nov 2007 12:05:31 -0500
From: "Tom Burns" <tom.i.burns@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Clarification re: outstanding IPC flaws
In-Reply-To: <671c20540711260901w6662fcabv779ce4fc51ec3d14@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <671c20540711260901w6662fcabv779ce4fc51ec3d14@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the double post.

On Nov 26, 2007 12:01 PM, Tom Burns <tom.i.burns@gmail.com> wrote:
> I have some questions about this comment.
>
> Most importantly - does this mean that if I have multiple processes
> queued inside semop() calls with sem_val = -1 (also, if it matters,
> SEM_UNDO flag is set),

This should read "sem_op = -1" as opposed to "sem_val = -1".

Cheers,
Tom Burns
