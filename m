Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621Ab0AUPCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab0AUPCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 10:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428Ab0AUPCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 10:02:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35913 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab0AUPCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 10:02:11 -0500
Date: Thu, 21 Jan 2010 13:02:05 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf top: losing events?
Message-ID: <20100121150205.GA24418@ghostprotocols.net>
References: <1264052528.26323.13.camel@marge.simson.net>
 <20100121122224.GA21083@ghostprotocols.net>
 <1264084112.5933.6.camel@marge.simson.net>
 <20100121144902.GA1244@ghostprotocols.net>
 <1264085772.5979.3.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264085772.5979.3.camel@marge.simson.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 21, 2010 at 03:56:12PM +0100, Mike Galbraith escreveu:
> On Thu, 2010-01-21 at 12:49 -0200, Arnaldo Carvalho de Melo wrote:
> > +	case PERF_RECORD_FORK:
> > +	case PERF_RECORD_EXIT:
> > +		event__process_task(event, session);
> > +		break;
> >  	default:
> >  		break;
> >  	}
> 
> Yup.  All better.
> 
> I figured that had to to be tied in from rummaging around earlier.

Thanks for testing!

I'm pushing these two fixes with your Tested-by tags.

- Arnaldo
