Return-Path: <linux-kernel-owner+w=401wt.eu-S1752198AbZIWOWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbZIWOWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 10:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZIWOW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 10:22:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:10978 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbZIWOW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 10:22:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CguFr4kCF4oBbx1nBHSUnAgsxFbHnqV10isKqskSE+5rdhXXiwGMWkjzJ51eDQHu2b
         aIh1lea6slUKz3137oR1OjS/E7AsfSPISduxJTlwpCfucamJ3sEif+FolP/X208Nl2r5
         ayuCoYagSbPYS4v7KKLQ+ukpFZ7XV4CRFayLc=
Date: Wed, 23 Sep 2009 16:22:25 +0200
From: Karol Lewandowski <karol.k.lewandowski@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Karol Lewandowski <karol.k.lewandowski@gmail.com>, david.graham@intel.com,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG 2.6.30+] e100 sometimes causes oops during resume
Message-ID: <20090923142225.GA2603@bizet.domek.prywatny>
References: <20090915120538.GA26806@bizet.domek.prywatny> <200909180027.37387.rjw@sisk.pl> <20090922233531.GA3198@bizet.domek.prywatny> <200909230151.36678.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909230151.36678.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 01:51:36AM +0200, Rafael J. Wysocki wrote:
> On Wednesday 23 September 2009, Karol Lewandowski wrote:
> > On Fri, Sep 18, 2009 at 12:27:37AM +0200, Rafael J. Wysocki wrote:
> > > Adding linux-mm to the CC list.
> > 
> > I've hit this bug 2 times since my last email.  Is there anything I
> > could do?
> > 
> > Maybe I should revert following commits (chosen somewhat randomly)?
> > 
> > 1. 49255c619fbd482d704289b5eb2795f8e3b7ff2e
> > 
> > 2. dd5d241ea955006122d76af88af87de73fec25b4 - alters changes made by
> > commit above
> > 
> > Any ideas?
> 
> You can try that IMO.

Reverting commits above made situation worse.  Hints?  Obvious
solutions? ;-)

Thanks.
