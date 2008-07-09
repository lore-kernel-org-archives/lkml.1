Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbYGIRpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbYGIRpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 13:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbYGIRo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 13:44:58 -0400
Received: from gw.goop.org ([64.81.55.164]:59224 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbYGIRo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 13:44:58 -0400
Message-ID: <4874F909.7060503@goop.org>
Date: Wed, 09 Jul 2008 10:44:41 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F30C.8020800@zytor.com>
In-Reply-To: <4874F30C.8020800@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Did the suspected linker bug issue ever get resolved?

I don't believe so.  I think Mike is getting very early crashes 
depending on some combination of gcc, linker and kernel config.  Or 
something.

This fragility makes me very nervous.  It seems hard enough to get this 
stuff working with current tools; making it work over the whole range of 
supported tools looks like its going to be hard.

    J
