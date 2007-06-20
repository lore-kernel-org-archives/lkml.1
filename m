Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbXFTIf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbXFTIf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 04:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbXFTIfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 04:35:21 -0400
Received: from ns.firmix.at ([62.141.48.66]:34219 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbXFTIfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 04:35:19 -0400
Subject: Re: Versioning file system
From: Bernd Petrovitsch <bernd@firmix.at>
To: Jack Stone <jack@hawkeye.stone.uk.eu.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Chris Snook <csnook@redhat.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       alan <alan@clueserver.org>
In-Reply-To: <46782AA5.2000108@hawkeye.stone.uk.eu.org>
References: <46731169.2090002@hawkeye.stone.uk.eu.org>
	 <4673182B.4090800@redhat.com> <46739E89.1080003@hawkeye.stone.uk.eu.org>
	 <46781A5B.9090104@redhat.com> <467829C4.5020101@zytor.com>
	 <46782AA5.2000108@hawkeye.stone.uk.eu.org>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Wed, 20 Jun 2007 10:34:53 +0200
Message-Id: <1182328493.32409.3.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -1.106 () AWL
X-Firmix-Spam-Status: No, hits=-1.106 required=5
X-Spam-Score: -1.106 () AWL
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-19 at 20:12 +0100, Jack Stone wrote:
> H. Peter Anvin wrote:
> > Chris Snook wrote:
> >> I pointed out NetApp's .snapshot directories because that's a method
> >> that uses legal path character, but doesn't break anything.  With this
> >> method, userspace tools will have to be taught that : is suddenly a
> >> special character.
> > 
> > Not to mention that the character historically used for this purpose is
> > ; (semicolon.)
> 
> But that would cause havoc with shells which use ; to seperate commands.

Then the user has to quote the ;. BTW `find` use a lone ';' since ages
to terminate it's '-exec' thingy.

> Using ; would defiantly break userspace

Only for buggy written shell scripts/commands. Who cares?

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


