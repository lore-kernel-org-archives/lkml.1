Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab0CLEXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 23:23:53 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:41279 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753067Ab0CLEXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 23:23:52 -0500
Message-ID: <4B99C1A1.3070402@st.com>
Date: Fri, 12 Mar 2010 09:52:57 +0530
From: Viresh KUMAR <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Lightning/1.0b1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, rajeev-dlh.kumar@st.com,
       shiraz.hashim@st.com, armando.visconti@st.com,
       ashish.priyadarshi@st.com, linux-kernel@vger.kernel.org,
       vipin.kumar@st.com, amit.goel@st.com, deepak.sikri@st.com
Subject: Re: [PATCH 05/11] ST SPEAr: Added clock framework for SPEAr	platform
 and machines
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com> <1267592861-26911-2-git-send-email-viresh.kumar@st.com> <1267592861-26911-3-git-send-email-viresh.kumar@st.com> <1267592861-26911-4-git-send-email-viresh.kumar@st.com> <1267592861-26911-5-git-send-email-viresh.kumar@st.com> <1267592861-26911-6-git-send-email-viresh.kumar@st.com> <20100311102845.GA16376@n2100.arm.linux.org.uk>
In-Reply-To: <20100311102845.GA16376@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/11/2010 3:58 PM, Russell King - ARM Linux wrote:
> On Wed, Mar 03, 2010 at 10:37:35AM +0530, Viresh KUMAR wrote:
>> +/* array of all spear 3xx clock lookups */
>> +static struct clk_lookup *spear_clk_lookups[] = {
>> +	/* root clks */
>> +	&osc_32k_cl,
>> +	&osc_24m_cl,
> 
> This is rather wasteful - rather than defining structures, and then having
> a one-time-used set of pointers to the structures, why not just declare
> the whole lot as an array like most other implementations do?
> 

I did it to make it more readable. But, obviously it is wasting some amount
of memory for just nothing. Will change it with an array implementation.

regards,
viresh kumar.
