Return-Path: <linux-kernel-owner+w=401wt.eu-S1751920AbYIUQGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbYIUQGV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 12:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYIUQF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 12:05:57 -0400
Received: from main.gmane.org ([80.91.229.2]:41467 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471AbYIUQF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 12:05:56 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ben Pfaff <blp@cs.stanford.edu>
Subject: Re: [PATCH] max3100 driver
Date: Sun, 21 Sep 2008 09:09:21 -0700
Message-ID: <87bpyhfpla.fsf@blp.benpfaff.org>
References: <1221895208650-git-send-email-chripell@gmail.com> <20080920012454.e40f03cc.akpm@linux-foundation.org> <20080920065652.11d76780@infradead.org>
Reply-To: blp@cs.stanford.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 76.14.48.56
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
Cancel-Lock: sha1:qPsiaSPP1apxfUlU+V8aDs9PKnU=
Cc: linux-serial@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> I do have a question though: what does a signed bitfield of 1 mean?
> I mean.. the variables are "int", so signed.... where will the compiler
> store the sign bit???

Whether a bit-field declared as type "int" is signed or unsigned
is compiler implementation-defined.  As C99 6.7.2 says (there is
similar text in C89):

     ...for bit-fields, it is implementation-defined whether the
     specifier int designates the same type as signed int or the
     same type as unsigned int.

Thus, it is never a good idea to declare a bit-field as plain
"int".  Declare it as "signed int" or "unsigned int" instead.
-- 
"Mon peu de succès près des femmes est toujours venu de les trop aimer."
--Jean-Jacques Rousseau

