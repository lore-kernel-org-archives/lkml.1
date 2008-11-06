Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbYKFUxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbYKFUxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 15:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbYKFUwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 15:52:50 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36776 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbYKFUwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 15:52:47 -0500
Subject: Re: [PATCH 0/5] eCryptfs: Filename Encryption
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: mhalcrow@linux.vnet.ibm.com
Cc: Pavel Machek <pavel@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dustin Kirkland <dustin.kirkland@gmail.com>,
       Eric Sandeen <sandeen@redhat.com>, Tyler C Hicks <tchicks@us.ibm.com>,
       David Kleikamp <shaggy@us.ibm.com>
In-Reply-To: <20081106202736.GC6688@halcrowt61p.austin.ibm.com>
References: <20081104213754.GC6675@halcrowt61p.austin.ibm.com>
	 <20081105155754.GA1759@ucw.cz>
	 <20081106202736.GC6688@halcrowt61p.austin.ibm.com>
Content-Type: text/plain
Date: Thu, 06 Nov 2008 14:52:26 -0600
Message-Id: <1226004746.8898.6.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-06 at 14:27 -0600, mhalcrow@linux.vnet.ibm.com wrote:
> On Wed, Nov 05, 2008 at 04:57:54PM +0100, Pavel Machek wrote:
> > On Tue 2008-11-04 15:37:54, Michael Halcrow wrote:
> > > This patchset implements filename encryption via a
> > > passphrase-derived mount-wide Filename Encryption Key (FNEK)
> > > specified as a mount parameter. Each encrypted filename has a
> > > fixed prefix indicating that eCryptfs should try to decrypt the
> > > filename. When eCryptfs encounters
> > 
> > That is 'interesting'. What happens if normal filename has that
> > prefix?
> 
> If the lower filename has the prefix but does not have a valid tag 70
> packet following the prefix, then eCryptfs will complain in the syslog
> and then pass through the lower filename as-is.

I'd recommend hiding this kind of syslog verbosity behind a debug config
option.  I think it would be very easy to create a DOS attack against
ecryptfs by putting all sorts of clever things in the lower file system.
-- 
David Kleikamp
IBM Linux Technology Center

