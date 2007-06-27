Return-Path: <linux-kernel-owner+w=401wt.eu-S1761133AbXF0RuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761133AbXF0RuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756361AbXF0Rt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:49:57 -0400
Received: from canuck.infradead.org ([209.217.80.40]:45697 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516AbXF0Rt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:49:56 -0400
Subject: Re: [PATCH] LinuxPPS (with new syscalls API)
From: David Woodhouse <dwmw2@infradead.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070627174537.GM13886@enneenne.com>
References: <20070626100628.GO24183@enneenne.com>
	 <1182855427.12109.203.camel@pmac.infradead.org>
	 <20070626170622.GA13886@enneenne.com>
	 <1182879520.3263.19.camel@shinybook.infradead.org>
	 <20070627101449.GH13886@enneenne.com>
	 <1182939510.6409.17.camel@pmac.infradead.org>
	 <20070627125802.GI13886@enneenne.com>
	 <1182960660.1170.12.camel@pmac.infradead.org>
	 <20070627174537.GM13886@enneenne.com>
Content-Type: text/plain
Date: Wed, 27 Jun 2007 18:49:48 +0100
Message-Id: <1182966588.1170.28.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-27 at 19:45 +0200, Rodolfo Giometti wrote:
> Ok. Please see the attached patch.

Looks better. All I can find to complain about is the fact that you
return whatever copy_from_user() returns. Don't -- that's the number of
bytes left to copy. It should be if (copy_from_user(..)) return -EFAULT;


-- 
dwmw2

