Return-Path: <linux-kernel-owner+w=401wt.eu-S936397AbXHOUCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936397AbXHOUCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 16:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933114AbXHOUCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 16:02:08 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:59128 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbXHOUCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 16:02:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NiLFqMg5jjvrBYrkyBRRIaOg69MNPnsa6/aHIvQ9YTSg8CnVNQKyDpp/1jGfQGDowhkMJS1gDcLFh3Y5HVjF4YOLDu/WXP6WZ/n+4STlN4vNVJ12pjlJZr+uHOIBeShditsJ3loecajMQdP5R/5BYPUuMb1+/o8gz9OpLQCQx1A=
Message-ID: <f36b08ee0708151302k1d3f28a0u38dee6e879ce81e1@mail.gmail.com>
Date: Wed, 15 Aug 2007 23:02:05 +0300
From: "Yakov Lerner" <iler.ml@gmail.com>
To: "Marc Perkel" <mperkel@yahoo.com>,
       "Kernel Linux" <linux-kernel@vger.kernel.org>
Subject: Re: Thinking outside the box on file systems
In-Reply-To: <106259.96671.qm@web52501.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <106259.96671.qm@web52501.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/07, Marc Perkel <mperkel@yahoo.com> wrote:
> I want to throw out some concepts about a new way of
> thinking about file systems. But the first thing you
> have to do is to forget what you know about file
> systems now. This is a discussion about a new view of
> looking a file storage that is radically different and
> it's more easily undersood if you forget a lot of what
> you know. The idea is to create what seems natural to
> the user rather than what seems natural to the
> programmer.


I believe that kernel interface is not really meant to be operated
on the level that's directly accessible by the end user.
The food chain is a bit different. The human user interacts
with userlevel apps, not with kernel API directly. The userlevel apps
interact in turn with the kernel APIs, either directly or via the
layers of libraries.

The abstrations that's presented to the human use are not necessarily 1:1
reflection of  the kernel APIs. For example, you could program your novel
way of permissions as a  new file manager application that
actually uses existing posix permissions underneath. Your file
manager could check with userlevel-stored policies to
implement the permissions that you describe, without any
changes in existing kernel and existing filesystems.

To expect that posix-compliant kernel will drop its posix
complicance for temporary experiment sounds a bit far-fetched
to me. But   the door for all kinds of experiments is widely
open in the userlevel.

Yakov
