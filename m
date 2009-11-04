Return-Path: <linux-kernel-owner+w=401wt.eu-S932182AbZKEA0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182AbZKEA0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 19:26:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbZKEA0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 19:26:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbZKEA0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 19:26:07 -0500
Date: Wed, 4 Nov 2009 18:49:23 -0500
From: Dave Jones <davej@redhat.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: Re: [MM] Make mm counters per cpu instead of atomic
Message-ID: <20091104234923.GA25306@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Christoph Lameter <cl@linux-foundation.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	"hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>
References: <alpine.DEB.1.10.0911041409020.7409@V090114053VZO-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0911041409020.7409@V090114053VZO-1>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 02:14:41PM -0500, Christoph Lameter wrote:
 
 > +		memset(m, sizeof(struct mm_counter), 0);

Args wrong way around.

	Dave
