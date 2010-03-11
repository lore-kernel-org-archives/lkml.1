Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab0CKK3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 05:29:32 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59668 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab0CKK3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 05:29:31 -0500
Date: Thu, 11 Mar 2010 10:28:45 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh KUMAR <viresh.kumar@st.com>
Cc: linux-arm-kernel@lists.infradead.org, rajeev-dlh.kumar@st.com,
       shiraz.hashim@st.com, armando.visconti@st.com,
       ashish.priyadarshi@st.com, linux-kernel@vger.kernel.org,
       vipin.kumar@st.com, amit.goel@st.com, deepak.sikri@st.com
Subject: Re: [PATCH 05/11] ST SPEAr: Added clock framework for SPEAr
	platform and machines
Message-ID: <20100311102845.GA16376@n2100.arm.linux.org.uk>
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com> <1267592861-26911-2-git-send-email-viresh.kumar@st.com> <1267592861-26911-3-git-send-email-viresh.kumar@st.com> <1267592861-26911-4-git-send-email-viresh.kumar@st.com> <1267592861-26911-5-git-send-email-viresh.kumar@st.com> <1267592861-26911-6-git-send-email-viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267592861-26911-6-git-send-email-viresh.kumar@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 10:37:35AM +0530, Viresh KUMAR wrote:
> +/* array of all spear 3xx clock lookups */
> +static struct clk_lookup *spear_clk_lookups[] = {
> +	/* root clks */
> +	&osc_32k_cl,
> +	&osc_24m_cl,

This is rather wasteful - rather than defining structures, and then having
a one-time-used set of pointers to the structures, why not just declare
the whole lot as an array like most other implementations do?
