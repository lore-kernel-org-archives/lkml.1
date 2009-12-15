Return-Path: <linux-kernel-owner+w=401wt.eu-S933356AbZLOTMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933356AbZLOTMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933335AbZLOTMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:12:30 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38205 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933075AbZLOTM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:12:29 -0500
Date: Tue, 15 Dec 2009 19:12:20 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Pavel Machek <pavel@ucw.cz>, Emese Revfy <re.emese@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 0/1] Constify struct address_space_operations for
	2.6.32-git-053fe57ac v2
Message-ID: <20091215191220.GW14381@ZenIV.linux.org.uk>
References: <cover.1260662994.git.re.emese@gmail.com> <20091214003836.GD7812@parisc-linux.org> <4B2595E7.701@gmail.com> <20091214021916.GB12196@linux-sh.org> <4B25E47C.1010803@gmail.com> <20091214112656.GB1959@elf.ucw.cz> <20091214080049.19930729@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091214080049.19930729@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 08:00:49AM -0800, Arjan van de Ven wrote:
> On Mon, 14 Dec 2009 12:26:56 +0100

> I for one am not opposed to using const where we could be using const.
> It's a fundamental language feature, that helps the compiler and
> developer. Yes there is sparse, and no, almost nobody uses that.
 
And as just about any language feature it can be used to make the thing
less readable.

Note that marking a pointer to method table as pointer to const is just fine;
nobody AFAICS has any problems with that.  It's "let's make pointers to
methods themselves const" that gets flamed.
