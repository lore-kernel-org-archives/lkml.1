Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbYJ1I2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbYJ1I2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 04:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbYJ1I2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 04:28:42 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:43879 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbYJ1I2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 04:28:40 -0400
Subject: Re: [GIT PULL/RESEND] kernel message catalog patches
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
In-Reply-To: <20081027092739.04b89526.randy.dunlap@oracle.com>
References: <1224230354.4631.1.camel@localhost>
	 <20081021092148.GB4980@osiris.boeblingen.de.ibm.com>
	 <alpine.LFD.2.00.0810230835150.3287@nehalem.linux-foundation.org>
	 <20081023210446.GA12003@osiris.boeblingen.de.ibm.com>
	 <alpine.LFD.2.00.0810231433380.3287@nehalem.linux-foundation.org>
	 <1225049195.14057.72.camel@localhost>
	 <alpine.LFD.2.00.0810261212290.5200@nehalem.linux-foundation.org>
	 <1225101688.15777.6.camel@localhost>
	 <alpine.LFD.2.00.0810270750100.3386@nehalem.linux-foundation.org>
	 <1225122726.15777.42.camel@localhost> <20081027161923.GE10603@mit.edu>
	 <20081027092739.04b89526.randy.dunlap@oracle.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Tue, 28 Oct 2008 09:25:56 +0100
Message-Id: <1225182356.15745.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 09:27 -0700, Randy Dunlap wrote:
> As I said a few months ago, please make it "almost kernel-doc style"
> but something that can be distinguished from the current kernel-doc.
> They aren't quite the same thing AFAICT.

The current format is this:

/*?
 * Tag: <component>.<hash>
 * Text: "<kmsg message text>"
 * Severity: <severity>
 * Parameter:
 *   @1: <description of the first message parameter>
 *   @2: <description of the second message parameter>
 *   ...
 * Description:
 * <What is the kmsg message all about>
 * User action:
 * <What can the user do to fix the problem>
 */

See the "/*?" vs "/**" ? The kmsg comments are kernel-doc style but not
the same as kernel-doc.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


