Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab0APTQO (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 14:16:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756272Ab0APTQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 14:16:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51583 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab0APTQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 14:16:12 -0500
Message-ID: <4B520E6D.5050505@zytor.com>
Date: Sat, 16 Jan 2010 11:07:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [0/9] 2.6.31.12-stable review
References: <20100114224848.GA532@kroah.com> <4B520D98.7030202@pardus.org.tr>
In-Reply-To: <4B520D98.7030202@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2010 11:03 AM, Ozan Çağlayan wrote:
> 
> 2. Boot hangs on old AMD Athlon XP Processors (not 64, not X2) with CONFIG_X86_CPU_DEBUG enabled kernels:
> http://groups.google.com/group/linux.kernel/browse_thread/thread/34ca6dd8aeab02b3/0c0acb9d6437756f?lnk=raot&fwc=1
> 

CONFIG_X86_CPU_DEBUG really turned out to be a bad idea.  We should kill
it off completely...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

