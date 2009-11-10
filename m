Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600AbZKJSik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbZKJSik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 13:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757578AbZKJSij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 13:38:39 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:34903 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757584AbZKJSii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 13:38:38 -0500
Message-ID: <4AF9B2CF.6050305@nortel.com>
Date: Tue, 10 Nov 2009 12:37:03 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: netdev@vger.kernel.org, Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: sunrpc port allocation and IANA reserved list
References: <4AF9A63B.6010101@nortel.com> <1257875623.2834.19.camel@achroite.uk.solarflarecom.com>
In-Reply-To: <1257875623.2834.19.camel@achroite.uk.solarflarecom.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2009 18:38:25.0670 (UTC) FILETIME=[FD0BA260:01CA6234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 11:53 AM, Ben Hutchings wrote:
> On Tue, 2009-11-10 at 11:43 -0600, Chris Friesen wrote:

>> Given that a userspace application can be stopped and restarted at any
>> time, and a sunrpc registration can happen at any time, what is the
>> expected mechanism to prevent the kernel from allocating a port for use
>> by sunrpc that reserved or well-known?
>>
>> Apparently Redhat and Debian have distro-specific ways of dealing with
>> this, but is there a standard solution?  Should there be?
>>
>> The current setup seems suboptimal.
> 
> I believe both RH and Debian are using the same implementation:
> <http://cyberelk.net/tim/software/portreserve/>.

That helps with the startup case, but still leaves a possible hole if an
app using a fixed port number is restarted at runtime.  During the
window where nobody is bound to the port, the kernel could randomly
assign it to someone else.

Chris
